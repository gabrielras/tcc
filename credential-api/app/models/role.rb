class Role < ApplicationRecord
  audited

  belongs_to :user
  belongs_to :institution

  has_enumeration_for :role_type, with: RoleTypes, create_helpers: true

  validates :role_type, presence: true
end
