# frozen_string_literal: true

module V1
  module CredentialEvents
    class Create < Actor
      input :attributes, type: Hash

      output :credential_event, type: CredentialEvent

      def call
        self.credential_event = CredentialEvent.new
        if event.state == 'in_revision'
          self.credential_event = CredencialEvent.create!(
            event_id: attributes[:event_id],
            method: attributes[:method],
            name: attributes[:name],
            author: attributes[:author],
            metadata: attributes[:metadata]
          )
        else
          fail!(error: "Somente é possível fazer alterações no estado de revisão")
        end
      rescue => e
        fail!(error: e.message)
      end
    end
  end
end
