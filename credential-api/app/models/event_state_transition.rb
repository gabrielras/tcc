class EventStateTransition < ApplicationRecord
  belongs_to :event, inverse_of: :state_transitions
end
