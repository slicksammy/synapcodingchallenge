require 'csv'

namespace :checkins do
  desc "Backfill deltas on weights"
  task backfill_deltas: :environment do
    Checkin.find_each do |c|
      previous_checkin = Checkin.where(person: c.person, event: c.event).where('created_at < ?', c.created_at).last
      if previous_checkin
        delta = c.weight - previous_checkin.weight
        c.delta = delta
        c.save
      end
    end
  end

  desc "Load Checkins from CSV"
  task load_checkins: :environment do
    # not many people so not worrying about performance
    CSV.foreach(Rails.root.join('weighins.csv'), headers: true) do |row|
      person = Person.find_by_name(row["Name"])
      sorted_events = person.leagues.map(&:event).sort_by(&:start_date)
      event = sorted_events.reverse.find { |e| e.start_date < Date.parse(row["Time"]) }
      Checkin.create!(person: person, event: event, weight: row["Weight"])
    end
  end
end
