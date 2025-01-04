class RenameIncomeToCashflow < ActiveRecord::Migration[8.0]
  def change
    rename_table :incomes, :cashflows
  end
end
