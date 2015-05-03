class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.integer :release_id
      t.integer :team_id
      t.string :scope_id

      t.timestamps null: false
    end
  end
end
