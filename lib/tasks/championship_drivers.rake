namespace :championship_drivers do
  desc 'Establishes championship_drivers including car number'
  task create: :environment do
    Driver.all.each do |driver|
      driver.inferred_championships.each do |championship|
        unless driver.championship_entry(championship).present?
          cd = ChampionshipDriver.new championship: championship, driver: driver, car_number: driver.car_number
          unless cd.save
            puts "Could not save #{driver.name} to #{championship.name} with car number #{driver.car_number}: #{cd.errors.full_messages.join(';')}"
          end
        end
      end
    end
  end
end