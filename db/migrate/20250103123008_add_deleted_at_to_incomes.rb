class AddDeletedAtToIncomes < ActiveRecord::Migration[8.0]
  def change
    add_column :cashflows, :deleted_at, :datetime
  end
end
