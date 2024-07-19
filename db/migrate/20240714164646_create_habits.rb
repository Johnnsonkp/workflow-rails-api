class CreateHabits < ActiveRecord::Migration[7.1]
  def change
    create_table :habits do |t|
      t.string :title
      t.text :description
      t.integer :current_streak

      t.timestamps
    end
  end
end
