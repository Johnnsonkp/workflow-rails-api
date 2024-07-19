class CreateEntries < ActiveRecord::Migration[7.1]
  def change
    create_table :entries do |t|
      t.string :date
      t.boolean :complete
      t.references :habit, null: false, foreign_key: true

      t.timestamps
    end
  end
end
