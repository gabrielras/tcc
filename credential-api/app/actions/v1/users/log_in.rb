# frozen_string_literal: true

module V1
  module Users
    class LogIn < Actor
      input :email, type: String
      input :password, type: String

      output :user, type: ::User
      output :token, type: String

      def call
        validate_email

        find_user = ::User.find_by(email: email)
        if find_user && find_user.authenticate(password)
          self.user = find_user
          self.token = user.generate_jwt
        else
          fail!(error: 'Error ao logar')
        end
      rescue ServiceActor::Failure => e
        fail!(error: e.message)
      end


      def validate_email
        if !email.match?(URI::MailTo::EMAIL_REGEXP)
          fail!(error: 'Formato de Email Inválido')
        end

        if ::User.find_by(email: email).blank?
          fail!(error: 'Email não foi encontrado')
        end
      end
    end
  end
end
