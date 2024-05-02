class Event < ApplicationRecord
  include Utils::HasStateMachine
  audited

  belongs_to :institution
  belongs_to :user

  has_many :credential_events, dependent: :destroy
  has_many :credentials, through: :credential_events

  validates :state, presence: true

  accepts_nested_attributes_for :credentials, reject_if: :all_blank, allow_destroy: true
end
