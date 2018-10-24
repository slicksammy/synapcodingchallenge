class CreateLeagueEventJoinTable < ActiveRecord::Migration
  def change
    create_join_table :leagues, :events do |t|
      t.index :league_id
      t.index :event_id
    end
  end
end
