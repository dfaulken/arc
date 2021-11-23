c = Championship.create name: "Apollo Racing Club Open Wheel Championship"

p1 = PointsSystem.create name: 'IndyCar points system, no rounds dropped, no finish points',
  worst_rounds_dropped: 0,
  pole_position_points: 1,
  any_lap_led_points: 1,
  most_laps_led_points: 2,
  race_finished_points: 0

p1.points_allocations.create position: 1,  points: 50
p1.points_allocations.create position: 2,  points: 40
p1.points_allocations.create position: 3,  points: 35
p1.points_allocations.create position: 4,  points: 32
p1.points_allocations.create position: 5,  points: 30
p1.points_allocations.create position: 6,  points: 28
p1.points_allocations.create position: 7,  points: 26
p1.points_allocations.create position: 8,  points: 24
p1.points_allocations.create position: 9,  points: 22
p1.points_allocations.create position: 10, points: 20
p1.points_allocations.create position: 11, points: 19
p1.points_allocations.create position: 12, points: 18
p1.points_allocations.create position: 13, points: 17
p1.points_allocations.create position: 14, points: 16
p1.points_allocations.create position: 15, points: 15

s1 = c.seasons.create name: 'IndyARC Season 1', index: 1, points_system: p1

mich = Track.create name: 'Michigan', track_type: TrackType::OVAL
lagu = Track.create name: 'Laguna Seca', track_type: TrackType::ROAD
phoe = Track.create name: 'Phoenix', track_type: TrackType::OVAL
ch_o = Track.create name: 'Charlotte Oval', track_type: TrackType::OVAL
monz = Track.create name: 'Monza', track_type: TrackType::ROAD

r1 = s1.races.create track: mich, date: Date.new(2020, 8, 30), index: 1, laps: 60
r2 = s1.races.create track: lagu, date: Date.new(2020, 9, 6), index: 2, laps: 40
r3 = s1.races.create track: phoe, date: Date.new(2020, 9, 13), index: 3, laps: 90
r4 = s1.races.create track: ch_o, date: Date.new(2020, 9, 20), index: 4, laps: 40
r5 = s1.races.create track: monz, date: Date.new(2020, 9, 27), index: 5, laps: 35

ggod = Driver.create name: 'Gary Godsoe'
dsta = Driver.create name: 'Duncan Starostka'
dumc = Driver.create name: 'Duane McCarthy'
mobe = Driver.create name: 'Maxxon Obenauer'
dmcc = Driver.create name: 'David McCourt'
jdup = Driver.create name: 'Joseph DuPont'
mric = Driver.create name: 'Matthew Rice'
tbor = Driver.create name: 'Tommy Bordeaux'
atho = Driver.create name: 'Adam Thomsen'
awil = Driver.create name: 'Alexander D Williams'
agor = Driver.create name: 'Andrew Gorringe'
asur = Driver.create name: 'Andrew Surowiec2'
rrav = Driver.create name: 'Rick Ravon'
dhel = Driver.create name: 'Daniel J Helm'
nwas = Driver.create name: 'Nicholas Wassenaar'
kfon = Driver.create name: 'Kory Fong'
jhed = Driver.create name: 'Jack Hedgcoxe'

r1.results.create driver: ggod, position: 1,  laps_led: 7, scored_pole_position: false, finished_race: true
r1.results.create driver: dsta, position: 2,  laps_led: 1, scored_pole_position: false, finished_race: true
r1.results.create driver: dumc, position: 3,  laps_led: 7, scored_pole_position: false, finished_race: true
r1.results.create driver: mobe, position: 4,  laps_led: 21, scored_pole_position: false, finished_race: true
r1.results.create driver: dmcc, position: 5,  laps_led: 11, scored_pole_position: false, finished_race: true
r1.results.create driver: jdup, position: 6,  laps_led: 9, scored_pole_position: false, finished_race: true
r1.results.create driver: mric, position: 7,  laps_led: 0, scored_pole_position: false, finished_race: true
r1.results.create driver: tbor, position: 8,  laps_led: 0, scored_pole_position: true, finished_race: true
r1.results.create driver: atho, position: 9,  laps_led: 0, scored_pole_position: false, finished_race: true
r1.results.create driver: awil, position: 10, laps_led: 1, scored_pole_position: false, finished_race: true
r1.results.create driver: agor, position: 11, laps_led: 0, scored_pole_position: false, finished_race: true
r1.results.create driver: asur, position: 12, laps_led: 0, scored_pole_position: false, finished_race: true
r1.results.create driver: rrav, position: 13, laps_led: 3, scored_pole_position: false, finished_race: true
r1.results.create driver: dhel, position: 14, laps_led: 0, scored_pole_position: false, finished_race: false
r1.results.create driver: nwas, position: 15, laps_led: 0, scored_pole_position: false, finished_race: false

r2.results.create driver: tbor, position: 1, laps_led: 40, scored_pole_position: true, finished_race: true
r2.results.create driver: dmcc, position: 2, laps_led: 0, scored_pole_position: false, finished_race: true
r2.results.create driver: dumc, position: 3, laps_led: 0, scored_pole_position: false, finished_race: true
r2.results.create driver: mobe, position: 4, laps_led: 0, scored_pole_position: false, finished_race: true
r2.results.create driver: kfon, position: 5, laps_led: 0, scored_pole_position: false, finished_race: true
r2.results.create driver: dsta, position: 6, laps_led: 0, scored_pole_position: false, finished_race: false
r2.results.create driver: asur, position: 7, laps_led: 0, scored_pole_position: false, finished_race: true

r3.results.create driver: rrav, position: 1, laps_led: 72, scored_pole_position: false, finished_race: true
r3.results.create driver: mobe, position: 2, laps_led: 9, scored_pole_position: false, finished_race: true
r3.results.create driver: mric, position: 3, laps_led: 0, scored_pole_position: false, finished_race: true
r3.results.create driver: dumc, position: 4, laps_led: 1, scored_pole_position: false, finished_race: true
r3.results.create driver: atho, position: 5, laps_led: 0, scored_pole_position: false, finished_race: true
r3.results.create driver: jhed, position: 6, laps_led: 5, scored_pole_position: false, finished_race: false
r3.results.create driver: tbor, position: 7, laps_led: 3, scored_pole_position: true, finished_race: true

r4.results.create driver: tbor, position: 1, laps_led: 20, scored_pole_position: false, finished_race: true
r4.results.create driver: mric, position: 2, laps_led: 0, scored_pole_position: false, finished_race: true
r4.results.create driver: mobe, position: 3, laps_led: 0, scored_pole_position: false, finished_race: true
r4.results.create driver: asur, position: 4, laps_led: 0, scored_pole_position: false, finished_race: true
r4.results.create driver: dsta, position: 5, laps_led: 0, scored_pole_position: false, finished_race: true
r4.results.create driver: dumc, position: 6, laps_led: 0, scored_pole_position: false, finished_race: true
r4.results.create driver: jdup, position: 7, laps_led: 0, scored_pole_position: false, finished_race: false
r4.results.create driver: agor, position: 8, laps_led: 0, scored_pole_position: false, finished_race: false
r4.results.create driver: rrav, position: 9, laps_led: 20, scored_pole_position: true, finished_race: false
r4.results.create driver: atho, position: 10, laps_led: 0, scored_pole_position: false, finished_race: false

r5.results.create driver: tbor, position: 1, laps_led: 32, scored_pole_position: false, finished_race: true
r5.results.create driver: dmcc, position: 2, laps_led: 3, scored_pole_position: true, finished_race: true
r5.results.create driver: dumc, position: 3, laps_led: 0, scored_pole_position: false, finished_race: true
r5.results.create driver: mobe, position: 4, laps_led: 0, scored_pole_position: false, finished_race: false
r5.results.create driver: mric, position: 5, laps_led: 0, scored_pole_position: false, finished_race: true
r5.results.create driver: asur, position: 6, laps_led: 0, scored_pole_position: false, finished_race: true
r5.results.create driver: dsta, position: 7, laps_led: 0, scored_pole_position: false, finished_race: true
r5.results.create driver: atho, position: 8, laps_led: 0, scored_pole_position: false, finished_race: true
r5.results.create driver: agor, position: 9, laps_led: 0, scored_pole_position: false, finished_race: false

RaceResult.all.each(&:calculate_and_persist_score!)