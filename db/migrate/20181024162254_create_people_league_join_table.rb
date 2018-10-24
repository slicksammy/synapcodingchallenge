class CreatePeopleLeagueJoinTable < ActiveRecord::Migration
  def change
    create_join_table :people, :leagues do |t|
      t.index :person_id
      t.index :league_id
    end
  end
end
