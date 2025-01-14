class AddCreditDebitToCashflows < ActiveRecord::Migration[8.0]
  def change
    add_column :cashflows, :credit_debit, :string
  end
end
