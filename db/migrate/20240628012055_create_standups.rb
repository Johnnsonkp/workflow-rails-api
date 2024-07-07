class CreateStandups < ActiveRecord::Migration[7.1]
  def change
    create_table :standups do |t|
      t.string :date

      t.timestamps
    end
  end
end
