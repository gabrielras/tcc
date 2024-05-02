# frozen_string_literal: true

module V1
  module Institutions
    class Create < Actor
      input :attributes, type: Hash
      input :user, type: User

      output :institution, type: Institution

      def call
        ActiveRecord::Base.transaction do
          self.institution = Institution.new(attributes)
          institution.save!

          Role.create!(user: user, institution: institution, role_type: 'owner')
        end
      end
    end
  end
end
