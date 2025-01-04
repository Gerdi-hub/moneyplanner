class RenameTypeInKeywords < ActiveRecord::Migration[8.0]
  def change
    rename_column :keywords, :type, :type_name
  end
end
