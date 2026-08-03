class FavoriteTasks < ApplicationRecord
  self.table_name = "favorite_tasks"
  self.primary_key = "id"

  belongs_to :user, class_name: "Users", foreign_key: "user_id"
  belongs_to :task, class_name: "Tasks", foreign_key: "task_id"

  validates :task_id, uniqueness: { scope: :user_id }
  validate :cannot_favorite_own_task

  private

  def cannot_favorite_own_task
    return unless task && user_id == task.user_id

    errors.add(:task_id, "自分のタスクはお気に入りにできません")
  end
end
