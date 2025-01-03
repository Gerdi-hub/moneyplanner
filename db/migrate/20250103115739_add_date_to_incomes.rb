class AddDateToIncomes < ActiveRecord::Migration[8.0]
  def change
    add_column :incomes, :date, :date
  end
end
