class CreateStandupTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :standup_tasks do |t|
      t.references :standup, null: false, foreign_key: true
      t.string :title
      t.boolean :complete, default: false

      t.timestamps
    end
  end
end
