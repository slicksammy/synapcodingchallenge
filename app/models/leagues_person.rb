class LeaguesPerson < ActiveRecord::Base
  belongs_to :league
  belongs_to :person
end
