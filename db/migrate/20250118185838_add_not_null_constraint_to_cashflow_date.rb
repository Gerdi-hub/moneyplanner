class AddNotNullConstraintToCashflowDate < ActiveRecord::Migration[8.0]
  def change
    change_column_null :cashflows, :date, false
  end
end
