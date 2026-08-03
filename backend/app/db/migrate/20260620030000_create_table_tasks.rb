class CreateTableTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :tasks do |t|
      t.references :user, null: false, foreign_key: { on_delete: :cascade }
      t.string :body, null: false
      t.boolean :is_completed, null: false, default: false

      t.timestamps
    end
  end
end
