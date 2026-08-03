class CreateTableFollows < ActiveRecord::Migration[8.1]
  def change
    create_table :follows do |t|
      t.bigint :user_id, null: false
      t.bigint :target_user_id, null: false
    end

    add_index :follows, [ :user_id, :target_user_id ], unique: true
    add_index :follows, :target_user_id
    add_foreign_key :follows, :users, column: :user_id, on_delete: :cascade
    add_foreign_key :follows, :users, column: :target_user_id, on_delete: :cascade
  end
end
