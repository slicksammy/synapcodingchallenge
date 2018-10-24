module ApplicationHelper
  def sort_people(event, people)
    people.sort { |a,b| a.up_by(event) && b.up_by(event) ? a.up_by(event) <=> b.up_by(event) : a.up_by(event) ? -1 : 1 }
  end
end
