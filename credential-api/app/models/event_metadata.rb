class EventMetadata < ApplicationRecord
  belongs_to :event

  belongs_to :credential, optional: true
  belongs_to :credential_event, optional: true

  validates :metadata, presence: true
end
