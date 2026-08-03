class UserAuthentications < ApplicationRecord
  include ::ActiveModel::SecurePassword

  # NOTE: 自動的に `password_digest` カラムに対してハッシュ化が行われる
  # NOTE: create 時は必ず `password` と `password_confirmation` 属性が必要
  has_secure_password

  self.table_name = "user_authentications"
  self.primary_key = "identifier"

  belongs_to :user, class_name: "Users", primary_key: "id", foreign_key: "user_id"

  validates :identifier, presence: true, uniqueness: true, length: { in: 8..32 }, format: { with: %r"\A[a-zA-Z0-9_]+\z" }
  validates :user_id, presence: true, uniqueness: true
  validates :password, presence: true, length: { in: 8..32 }, format: { with: %r"\A[a-zA-Z0-9_@-]+\z" }, confirmation: true
  validates :password_confirmation, presence: true
end
