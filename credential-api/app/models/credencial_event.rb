class CredencialEvent < ApplicationRecord
  belongs_to :event
  belongs_to :credential, optional: true

  has_enumeration_for :method_type, with: MethodTypes, create_helpers: true

  validates :method_type, presence: true

  validates :name, presence: true
  validates :author, presence: true
  validates :metadata, presence: true
end
