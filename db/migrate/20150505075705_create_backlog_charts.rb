class CreateBacklogCharts < ActiveRecord::Migration
  def change
    create_table :backlog_charts do |t|
    	t.integer :not_start
    	t.integer :dev_in_progress
    	t.integer :qa_in_progress
    	t.integer :done

    	t.integer :team_id
    	
      t.timestamps null: false
    end
  end
end
