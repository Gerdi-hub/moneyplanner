class DropExpensesAndRecordsTables < ActiveRecord::Migration[8.0]
  def up
    drop_table :expenses
    drop_table :records
  end
end
