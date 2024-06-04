class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.string :description
      t.string :status
      t.integer :order
      t.string :number
      t.string :start_date
      t.string :time_to_start
      t.string :time_to_finish

      t.timestamps
    end
  end
end
