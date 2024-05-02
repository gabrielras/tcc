# frozen_string_literal: true

module V1
  module Events
    class Start < Actor
      input :event, type: Event

      def call
        event.transition_to!(:start)
        estimated_cost = 0

        event.credentials.each do |credential|
          Open3.popen3("#{Rails.root.join("connect-blockchain/connect.js")} node.js #{attributes}") do |stdin, stdout, stderr, wait_thr|
            output = stdout.read
            exit_status = wait_thr.value
            unless exit_status.success?
              fail!(error: "#{stderr.read}")
            end
          end
        end

        event.transition_to!(:pricing)
        event.update!(estimated_cost: estimated_cost, estimated_cost_date: Time.zone.now)
      end
    end
  end
end
