class AddTypeAndCreditDebitToCashflows < ActiveRecord::Migration[8.0]
  def change
    add_column :cashflows, :type, :string
    add_column :cashflows, :credit_debit, :string
  end
end
