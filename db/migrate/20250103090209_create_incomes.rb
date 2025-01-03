class CreateIncomes < ActiveRecord::Migration[8.0]
  def change
    create_table :cashflows do |t|
      t.decimal :amount
      t.string :description
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
