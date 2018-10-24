require 'csv'

namespace :participants do
  desc "Load Events, People, Leagues from CSV"
  task load_from_csv: :environment do
    
    people_hash = Hash.new
    events_hash = Hash.new
    leagues_people = Hash.new

    CSV.foreach(Rails.root.join('participants.csv'), headers: true) do |row|
      
      unless people_hash[row["Name"]]
        person_id = Person.create!(name: row["Name"]).id
        people_hash[row["Name"]] = person_id
        leagues_people[row["Name"]] = {}
      end

      unless events_hash[row["Event"]]
        event_id = Event.create!(name: row["Event"], start_date: row["Date"]).id
        events_hash[row["Event"]] = {id: event_id}
      end

      if row["League"] && !events_hash[row["Event"]][row["League"]]
        league_id = League.create!(name: row["League"], event_id: events_hash[row["Event"]][:id]).id
        events_hash[row["Event"]][row["League"]] = league_id
      end

      if row["League"] && !leagues_people[row["Name"]][["League"]]
        LeaguesPerson.create!(league_id: events_hash[row["Event"]][row["League"]], person_id: people_hash[row["Name"]])
        leagues_people[row["Name"]][row["League"]] = true
      end
    end

  end
end
