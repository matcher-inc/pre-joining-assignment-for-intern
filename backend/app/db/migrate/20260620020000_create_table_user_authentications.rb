class CreateTableUserAuthentications < ActiveRecord::Migration[8.1]
  def change
    create_table :user_authentications, id: false do |t|
      t.primary_key :identifier, :string
      t.bigint :user_id, null: false
      t.string :password_digest, null: false
    end

    add_index(
      :user_authentications,
      :user_id,
      if_not_exists: true,
      unique: true
    )

    add_foreign_key(
      :user_authentications,
      :users,
      if_not_exists: true,
      column: :user_id,
      primary_key: :id,
      on_delete: :cascade
    )
  end
end
