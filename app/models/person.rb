class Person < ActiveRecord::Base

  has_many :checkins
  has_many :user_person_joins
  has_many :users, through: :user_person_joins
  has_many :leagues_people
  has_many :leagues, through: :leagues_people

  def leagues_for_event(event)
    leagues.for_event(event)
  end

  def up_by(event=nil)
    return attributes['up_by'] unless event
    checkins_from_event = event.checkins.where(person: self).order(:created_at)
    first_checkin = checkins_from_event.first
    last_checkin = checkins_from_event.last
    last_checkin == first_checkin ? nil : last_checkin.weight - first_checkin.weight
  end

  def up_by_percentage(event=nil)
    return attributes['up_by'] unless event
    checkins_from_event = event.checkins.where(person: self).order(:created_at)
    first_checkin = checkins_from_event.first
    last_checkin = checkins_from_event.last
    last_checkin == first_checkin ? nil : (last_checkin.weight - first_checkin.weight).to_f / first_checkin.weight.to_f * 100.to_f
  end

  def percentage_change(event: nil)
    # return unless up_by
    @percentage_change ||= starting_weight ?  up_by(event).to_f / starting_weight * 100 : nil
  end

  def checkin_diffs
    grouped = checkins.includes(:event).order('events.created_at').group_by(&:event)
    event_diffs = {}
    grouped.each_pair do |event, event_checkins|
      diffs = event_checkins.sort_by(&:created_at).map(&:delta).compact
      event_diffs[event.try(:name)] = diffs.map { |d| '%.2f' % d }
    end
    event_diffs
  end
end
