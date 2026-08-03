class Tasks < ApplicationRecord
  self.table_name = "tasks"
  self.primary_key = "id"

  belongs_to :user, class_name: "Users", foreign_key: "user_id"
  has_many :favorite_tasks, class_name: "FavoriteTasks", foreign_key: "task_id", dependent: :destroy

  validates :body, presence: true
end
