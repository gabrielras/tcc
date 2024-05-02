# frozen_string_literal: true

module V1
  module Events
    class State < Actor
      input :event, type: Event
      input :to_state, type: String

      def call
        unless event.can_transition_to?(to_state.to_sym)
          fail!(error: "Não é possível alterar para esse estado")
        end

        if event.state == 'start'
          V1::Events::Start.result(event: event)
        elsif event.state == 'pricing'
          V1::Events::Pricing.result(event: event)
        else
          event.transition_to!(to_state.to_sym)
        end
      rescue => e
        fail!(error: e.message)
      end
    end
  end
end
