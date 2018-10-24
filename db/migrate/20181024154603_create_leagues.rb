class CreateLeagues < ActiveRecord::Migration
  def change
    create_table :leagues do |t|
      t.references :event, index: true
      t.string :name
      t.string :tagline

      t.timestamps
    end
  end
end
