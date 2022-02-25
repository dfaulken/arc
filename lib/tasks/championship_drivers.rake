namespace :championship_drivers do
  desc 'Establishes championship_drivers including car number'
  task create: :environment do
    Driver.all.each do |driver|
      driver.inferred_championships.each do |championship|
        ChampionshipDriver.create! championship: championship, driver: driver, car_number: driver.car_number
      end
    end
  end
end