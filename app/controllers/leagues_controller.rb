class LeaguesController < ApplicationController
  include ApplicationHelper
  def index
    @leagues = League.all
  end

  def show
    @league = League.find(params[:id])
    @event = @league.event
    @sorted_people = sort_people(@event, @league.people)
  end
end
