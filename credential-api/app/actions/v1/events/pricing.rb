# frozen_string_literal: true

module V1
  module Events
    class Pricing < Actor
      input :event, type: Event

      def call
        @estimated_cost = 0

        event.credential_events.each do |credential_event|
          begin
            function_name = 'addCredential'
            attributes = ["123", "John Doe", "ABC123", "Alice", "Some metadata", "Event123"].map { |arg| arg.inspect }.join(" ")

            command = "node #{Rails.root.join("../connect-blockchain/ethereum/CredentialsContract.js")} #{function_name} #{attributes}"
            Open3.popen3(command) do |stdin, stdout, stderr, wait_thr|
              if wait_thr.value.success?
                output = stdout.read
                puts "Success: #{output}"
              else
                errors = stderr.read
                puts "Error: #{errors}"
              end
            end
          rescue => e

          end
        end

        event.transition_to!(:pricing)
        event.update!(estimated_cost: @estimated_cost, estimated_cost_date: Time.zone.now)
      end
    end
  end
end
