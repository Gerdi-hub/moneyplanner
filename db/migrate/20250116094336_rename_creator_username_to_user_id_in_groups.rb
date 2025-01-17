class RenameCreatorUsernameToUserIdInGroups < ActiveRecord::Migration[8.0]
  def change
    rename_column :groups, :creator_username, :user_id
  end
end
