class AddDeviseToUsers < ActiveRecord::Migration[8.0]
  def self.up
    change_table :users, bulk: true do |t|
      # Kontrollime ja lisame ainult siis, kui veerg pole olemas
      unless column_exists?(:users, :email)
        ## Database authenticatable
        t.string :email,              null: false, default: ""
      end

      unless column_exists?(:users, :encrypted_password)
        t.string :encrypted_password, null: false, default: ""
      end

      unless column_exists?(:users, :reset_password_token)
        ## Recoverable
        t.string   :reset_password_token
        t.datetime :reset_password_sent_at
      end

      unless column_exists?(:users, :remember_created_at)
        ## Rememberable
        t.datetime :remember_created_at
      end
    end

    # Kontrollime ja lisame indeksid ainult siis, kui pole olemas
    unless index_exists?(:users, :email)
      add_index :users, :email,                unique: true
    end

    unless index_exists?(:users, :reset_password_token)
      add_index :users, :reset_password_token, unique: true
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
