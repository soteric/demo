class CreateReleases < ActiveRecord::Migration
  def change
    create_table :releases do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
