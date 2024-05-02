class Credencial < ApplicationRecord
  audited
  belongs_to :institution

  has_many :credential_events, dependent: :destroy
  has_many :events, through: :credential_events

  validates :name, presence: true
  validates :author, presence: true
  validates :metadata, presence: true
end
