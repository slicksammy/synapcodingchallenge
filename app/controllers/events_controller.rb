class EventsController < ApplicationController
  include ApplicationHelper

  def index
    @events = Event.all.order(:id)
  end

  def show
    @event = Event.find(params[:id])
    @leagues = @event.leagues
    @sorted_people = sort_people(@event, @event.people)
    @sorted_people_leauges = @sorted_people.map{ |p| [p.id, p.leagues_for_event(@event)] }.to_h
  end

  def create
    @event = Event.create(event_params)
    redirect_to people_path
  end

  private

  def event_params
    params.require(:event).permit(:name, :tagline)
  end
end
