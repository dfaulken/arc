namespace :incident_outcomes do
  desc 'Sets incident outcome expiration dates to the default for each incident oucome.'
  task set_default_expiration_dates: :environment do
    IncidentOutcome.active.each do |io|
      old_date = io.expires_at
      new_date = io.default_expiration_date
      io.update! expires_at: new_date
      puts "Incident outcome for #{io.driver.name} at #{io.incident.race.name}: changed from #{format_date old_date} to #{format_date new_date}."
    end
  end
end

def format_date(date)
  date.strftime '%A, %B %e, %Y'
end
