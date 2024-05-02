# frozen_string_literal: true

class EventStateMachine
  include Statesman::Machine

  state :in_revision
  state :rejected
  state :approved
  state :pricing
  state :start
  state :concluded
  state :partial_concluded

  transition from: :in_revision, to: %i[rejected approved]
  transition from: :rejected, to: %i[in_revision]
  transition from: :approved, to: %i[pricing rejected]
  transition from: :pricing, to: %i[start rejected]
  transition from: :start, to: %i[concluded partial_concluded]

  after_transition(after_commit: true) do |event, transition|
    event.update!(state: transition.to_state)
  end
end
