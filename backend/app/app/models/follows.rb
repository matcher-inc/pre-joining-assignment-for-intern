class Follows < ApplicationRecord
  self.table_name = "follows"
  self.primary_key = "id"

  belongs_to :user, class_name: "Users", foreign_key: "user_id"
  belongs_to :target_user, class_name: "Users", foreign_key: "target_user_id"

  validates :target_user_id, uniqueness: { scope: :user_id }
  validate :cannot_follow_self

  private

  def cannot_follow_self
    return unless user_id == target_user_id

    errors.add(:target_user_id, "自分自身はフォローできません")
  end
end
