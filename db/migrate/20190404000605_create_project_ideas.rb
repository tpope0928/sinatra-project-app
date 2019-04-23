class CreateProjectIdeas < ActiveRecord::Migration
  def change
    create_table :project_ideas do |t|
      t.string :title
      t.string :content
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
