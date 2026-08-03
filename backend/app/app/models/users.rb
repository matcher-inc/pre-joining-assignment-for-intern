class Users < ApplicationRecord
  self.table_name = "users"
  self.primary_key = "id"

  has_one :user_authentication, class_name: "UserAuthentications", foreign_key: "user_id"
  has_many :tasks, class_name: "Tasks", foreign_key: "user_id", dependent: :destroy
  has_many :favorite_tasks, class_name: "FavoriteTasks", foreign_key: "user_id", dependent: :destroy
  has_many :favorited_tasks, through: :favorite_tasks, source: :task
  has_many :active_follows, class_name: "Follows", foreign_key: "user_id", dependent: :destroy
  has_many :following_users, through: :active_follows, source: :target_user
  has_many :passive_follows, class_name: "Follows", foreign_key: "target_user_id", dependent: :destroy

  validates :name, presence: true
end
