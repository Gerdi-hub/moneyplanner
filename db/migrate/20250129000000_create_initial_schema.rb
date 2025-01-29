class CreateInitialSchema < ActiveRecord::Migration[8.0]
  def change
    create_table "cashflows" do |t|
      t.decimal "amount"
      t.string "description"
      t.integer "user_id", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.date "date", null: false
      t.datetime "deleted_at"
      t.string "type_name"
      t.string "credit_debit"
      t.index ["user_id"], name: "index_cashflows_on_user_id"
    end

    create_table "groups" do |t|
      t.string "name"
      t.string "user_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    create_table "keywords" do |t|
      t.string "name"
      t.string "type_name"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    create_table "memberships" do |t|
      t.integer "user_id", null: false
      t.integer "group_id", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["group_id"], name: "index_memberships_on_group_id"
      t.index ["user_id"], name: "index_memberships_on_user_id"
    end

    create_table "users" do |t|
      t.string "email", default: "", null: false
      t.string "encrypted_password", default: "", null: false
      t.string "reset_password_token"
      t.datetime "reset_password_sent_at"
      t.datetime "remember_created_at"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "username"
      t.index ["email"], name: "index_users_on_email", unique: true
      t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
      t.index ["username"], name: "index_users_on_username", unique: true
    end

    add_foreign_key "cashflows", "users"
    add_foreign_key "memberships", "groups"
    add_foreign_key "memberships", "users"
  end
end
