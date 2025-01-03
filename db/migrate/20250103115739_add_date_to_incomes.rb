class AddDateToIncomes < ActiveRecord::Migration[8.0]
  def change
    add_column :cashflows, :date, :date
  end
end
