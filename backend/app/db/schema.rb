# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_07_26_010000) do
  create_table "favorite_tasks", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "task_id", null: false
    t.bigint "user_id", null: false
    t.index ["task_id"], name: "index_favorite_tasks_on_task_id"
    t.index ["user_id", "task_id"], name: "index_favorite_tasks_on_user_id_and_task_id", unique: true
    t.index ["user_id"], name: "index_favorite_tasks_on_user_id"
  end

  create_table "follows", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "target_user_id", null: false
    t.bigint "user_id", null: false
    t.index ["target_user_id"], name: "index_follows_on_target_user_id"
    t.index ["user_id", "target_user_id"], name: "index_follows_on_user_id_and_target_user_id", unique: true
  end

  create_table "tasks", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "body", null: false
    t.datetime "created_at", null: false
    t.boolean "is_completed", default: false, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "user_authentications", primary_key: "identifier", id: :string, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "password_digest", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_user_authentications_on_user_id", unique: true
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
  end

  add_foreign_key "favorite_tasks", "tasks", on_delete: :cascade
  add_foreign_key "favorite_tasks", "users", on_delete: :cascade
  add_foreign_key "follows", "users", column: "target_user_id", on_delete: :cascade
  add_foreign_key "follows", "users", on_delete: :cascade
  add_foreign_key "tasks", "users", on_delete: :cascade
  add_foreign_key "user_authentications", "users", on_delete: :cascade
end
