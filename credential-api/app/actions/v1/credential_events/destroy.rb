# frozen_string_literal: true

module V1
  module CredentialEvents
    class Destroy < Actor
      input :credential_event, type: CredentialEvent

      def call
        ActiveRecord::Base.transaction do
          if event.state == 'in_revision'
            self.credential_event.destroy
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
