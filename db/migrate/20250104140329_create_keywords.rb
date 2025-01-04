class CreateKeywords < ActiveRecord::Migration[8.0]
  def change
    create_table :keywords do |t|
      t.string :name
      t.string :type

      t.timestamps
    end
  end
end
