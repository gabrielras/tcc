# frozen_string_literal: true

module V1
  module CredentialEvents
    class Update < Actor
      input :credential_event, type: CredentialEvent
      input :attributes, type: Hash

      def call
        ActiveRecord::Base.transaction do
          if event.state == 'in_revision'
            self.credential.update!(
              event: event,
              method: attributes[:method],
              name: attributes[:name],
              author: attributes[:author],
              metadata: attributes[:metadata]
            )
          else
            fail!(error: "Somente é possível fazer alterações no estado de revisão")
          end
        end
      rescue => e
        fail!(error: e.message)
      end
    end
  end
end
