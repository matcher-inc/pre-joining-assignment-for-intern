class CreateTableFavoriteTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :favorite_tasks do |t|
      t.references :user, null: false, foreign_key: { on_delete: :cascade }
      t.references :task, null: false, foreign_key: { on_delete: :cascade }
    end

    add_index :favorite_tasks, [ :user_id, :task_id ], unique: true
  end
end
