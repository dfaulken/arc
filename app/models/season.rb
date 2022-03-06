class Season < ApplicationRecord
  has_many :races
  has_many :results, through: :races
  has_many :scores, through: :results
  has_many :drivers, through: :races
  has_many :standings, class_name: 'SeasonStanding', inverse_of: :season
  has_many :teams
  has_many :team_standings, through: :teams
  belongs_to :championship
  belongs_to :points_system

  default_scope { order :index }

  validates :index, presence: true, uniqueness: { scope: :championship }
  validates :name, presence: true, uniqueness: { scope: :championship }

  validate :points_system_allocations_can_accommodate_results

  def calculate_scores!
    results.each do |result|
      score = result.scores.find_by points_system: points_system
      if score
        score.calculate!
        score.save
      else result.calculate_and_persist_score!
      end
    end
  end

  def calculate_standings!
    calculate_driver_standings!
    if teams.any?
      calculate_team_standings!
    end
  end

  def calculate_driver_standings!
    standings.delete_all
    if championship.combined?
      championship.track_types.each do |track_type|
        calculate_standings_for! track_type
      end
    end
    calculate_standings_for! TrackType.any
  end

  def calculate_team_standings!
    teams.each do |team|
      team.team_standings.delete_all if team.team_standings.present?
    end
    if championship.combined?
      championship.track_types.each do |track_type|
        calculate_team_standings_for! track_type
      end
    end
    calculate_team_standings_for! TrackType.any
  end

  def calculate_projection(provisional_results)
    provisional_scores = grouped_scores(TrackType.any)
    provisional_results.each do |result|
      unless provisional_scores.key? result.driver
        provisional_scores[result.driver] = {}
      end
      driver_scores = provisional_scores[result.driver]
      driver_scores[result.race] = result.calculate_score
    end
    projection = []
    standings = calculate_standings_for(TrackType.any, provisional_scores)
    sorted_drivers = standings.keys.sort_by do |driver|
      standings[driver].first
    end
    sorted_drivers.each do |driver|
      projection << [driver.name, standings[driver].first * -1]
    end
    projection
  end

  def calculate_standings_for(track_type, grouped_scores)
    grouped_sorters = {}
    grouped_scores.each_pair do |driver, race_score_map|
      all_driver_scores = race_score_map.keys.sort_by(&:date).map{ |race| race_score_map[race] }
      best_result = all_driver_scores.compact.map(&:race_result).min_by(&:position)
      best_result_score = race_score_map[best_result.race]
      included_driver_scores = drop_scores(all_driver_scores, track_type)
      dropped_scores = (all_driver_scores - included_driver_scores).compact
      base_points = all_driver_scores.compact.sum(&:points)
      dropped_points = dropped_scores.sum(&:points)
      points = base_points - dropped_points
      # Points, best result, count of best result, index of first race where best result was scored
      grouped_sorters[driver] = [
        points * -1, # flip for sorting, flip back for recording
        best_result.position,
        all_driver_scores.compact.count{|score| score.race_result.position == best_result.position } * -1, # flip for sorting
        all_driver_scores.index(best_result_score),
        dropped_scores
      ]
    end
    grouped_sorters
  end

  def calculate_team_standings_for(track_type, grouped_driver_scores)
    grouped_sorters = {}
    teams.each do |team|
      team_scores = []
      team.drivers.each do |driver|
        team_scores += grouped_driver_scores[driver].values.compact
      end
      points = team_scores.sum(&:points)
      best_and_earliest_result = team_scores.map(&:race_result).min_by{ |rr| [rr.position, rr.race.date]}
      grouped_sorters[team] = [
        points * -1, # flip for sorting, flip back for recording
        best_and_earliest_result.position,
        team_scores.count{|s| s.race_result.position == best_and_earliest_result.position} * -1, # flip for sorting
        races.index(best_and_earliest_result.race)
      ]
    end
    grouped_sorters
  end

  def drivers_without_teams
    championship.drivers - drivers.joins(team_memberships: :team).where(teams: { season: self })
  end

  def finish_date
    races.last.date + 1.day
  end

  def grouped_results(track_type = TrackType.any)
    groups = results.of_type(track_type).group_by(&:driver)
    grouped = {}
    groups.each_pair do |driver, driver_results|
      indexed_results = {}
      driver_results.each do |result|
        indexed_results[result.race] = result
      end
      grouped[driver] = indexed_results
    end
    grouped
  end

  def grouped_scores(track_type = TrackType.any)
    groups = scores.joins(race_result: { race: :track })
      .includes(race_result: [:race, :driver])
      .where(points_system: points_system, tracks: { track_type: track_type })
      .group_by{|score| score.race_result.driver }
    grouped = {}
    groups.each_pair do |driver, driver_scores|
      indexed_scores = {}
      races.each do |race|
        next unless race.of_type? track_type
        indexed_scores[race] = driver_scores.find do |score|
          score.race_result.race == race
        end
      end
      grouped[driver] = indexed_scores
    end
    grouped
  end

  def grouped_standings(track_type = nil)
    grouped = {}
    standings.includes(:dropped_races)
      .where(track_type: SeasonStanding.effective_track_type(track_type))
      .each do |standing|
      grouped[standing.driver] = standing
    end
    grouped
  end

  def grouped_team_standings(track_type = nil)
    grouped = {}
    teams.each do |team|
      standing = team.team_standings.find_by(track_type: SeasonStanding.effective_track_type(track_type))
      grouped[team] = standing if standing.present?
    end
    grouped
  end

  def grouped_points_progression(track_type = TrackType.any)
    grouped = {}
    track_type_races = races.select do |race|
      race.of_type?(track_type)
    end
    grouped_scores.each_pair do |driver, indexed_scores|
      scores_so_far = {}
      track_type_races.each do |race|
        scores_so_far[race] = nil
      end
      points_progression = []
      track_type_races.each do |race|
        scores_so_far[race] = indexed_scores[race]
        included_scores = drop_scores(scores_so_far.values, track_type)
        if race.results.any?
          points_progression << included_scores.compact.sum(&:points)
        end
      end
      grouped[driver.name] = points_progression
    end
    grouped
  end

  def next_team_name
    "Team #{teams.count.succ}"
  end

  def ongoing?
    races.any? do |race|
      race.results.none?
    end
  end

  def scores_to_drop(track_type)
    if track_type == TrackType.any
      points_system.worst_rounds_dropped
    else
      points_system.worst_rounds_dropped / championship.track_types.count
    end
  end

  private

  def calculate_standings_for!(track_type)
    grouped_sorters = calculate_standings_for(track_type, grouped_scores(track_type))
    sorted_drivers = grouped_sorters.keys.sort_by do |driver|
      grouped_sorters[driver]
    end
    sorted_drivers.each.with_index(1) do |driver, position|
      points, _best_result_position, _count_of_best_result, _index_of_best_result, dropped_scores = grouped_sorters[driver]
      standing = standings.create! driver: driver, position: position, points: points * -1, 
        track_type: SeasonStanding.effective_track_type(track_type)
      dropped_scores.each do |score|
        standing.dropped_races.create! race_result: score.race_result
      end
    end
  end

  def calculate_team_standings_for!(track_type)
    grouped_sorters = calculate_team_standings_for(track_type, grouped_scores(track_type))
    sorted_teams = grouped_sorters.keys.sort_by do |team|
      grouped_sorters[team]
    end
    sorted_teams.each.with_index(1) do |team, position|
      points, _best_result_position, _count_of_best_result, _index_of_best_result = grouped_sorters[team]
      team.team_standings.create! position: position, points: points * -1,
        track_type: SeasonStanding.effective_track_type(track_type)
    end
  end

  def drop_scores(scores, track_type)
    scores = scores.clone
    drop_count = scores_to_drop(track_type)
    drop_count = 0 if scores.count < drop_count
    drop_count.times do 
      if scores.include? nil
        scores.delete_at scores.index(nil)
      else
        drop_score = scores.min_by(&:points)
        scores.delete drop_score
      end
    end
    scores
  end

  def points_system_allocations_can_accommodate_results
    max_allocation = points_system.points_allocations.pluck(:position).max
    return if max_allocation.nil?
    max_result = results.pluck(:position).max
    return if max_result.nil?
    if max_result > max_allocation
      errors.add :points_system, "cannot be used for this season, " +
        "as it is only configured to allocate points as far as position #{max_allocation}. " +
        "This season currently requires a points system to allocate points as far as position #{max_result}."
    end
  end
end