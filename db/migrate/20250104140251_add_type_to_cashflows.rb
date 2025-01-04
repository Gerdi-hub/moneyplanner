class AddTypeToCashflows < ActiveRecord::Migration[8.0]
  def change
    add_column :cashflows, :type, :string
  end
end
