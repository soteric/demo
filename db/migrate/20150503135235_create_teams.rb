class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.integer :pillar_id

      t.timestamps null: false
    end
  end
end
