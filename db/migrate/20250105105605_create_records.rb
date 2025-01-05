class CreateRecords < ActiveRecord::Migration[8.0]
  def change
    create_table :records do |t|
      t.timestamps
    end
  end
end
