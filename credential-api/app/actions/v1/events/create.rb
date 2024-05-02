# frozen_string_literal: true


module V1
  module Events
    class Create < Actor
      input :attributes, type: Hash

      output :event, type: Event

      def call
        self.event = Event.new(attributes.merge(state: 'in_revision'))
        event.save!
      end
    end
  end
end
