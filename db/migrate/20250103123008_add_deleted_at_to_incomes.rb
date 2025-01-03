class AddDeletedAtToIncomes < ActiveRecord::Migration[8.0]
  def change
    add_column :incomes, :deleted_at, :datetime
  end
end
