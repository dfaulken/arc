module RaceResultsHelper
  def race_result_classes(result)
    classes = []
    classes << case result.position
    when 1 then 'p1'
    when 2 then 'p2'
    when 3 then 'p3'
    when 4..10 then 'p4-p10'
    else 'below-p10'
    end
    classes << 'pole' if result.scored_pole_position?
    classes << 'led-lap' if result.laps_led > 0
    classes << 'most-laps-led' if result.most_laps_led?
    classes << 'non-finisher' unless result.finished_race?
    classes.join ' '
  end

  def standing_class(standing)
    case standing.position
    when 1 then 'p1'
    when 2 then 'p2'
    when 3 then 'p3'
    when 4..10 then 'p4-p10'
    else 'below-p10'
    end
  end
end
