class Institution < ApplicationRecord
  has_many :roles, dependent: :destroy

  has_many :credentials, through: :credentials

  validates :name, presence: true, uniqueness: true
end
