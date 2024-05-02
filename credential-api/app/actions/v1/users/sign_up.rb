# frozen_string_literal: true

module V1
  module Users
    class SignUp < Actor
      input :attributes, type: Hash

      output :user, type: ::User
      output :token, type: String

      def call
        self.user = ::User.new(attributes)

        validate_email
        validate_password
        validate_first_name
        validate_last_name

        user.save!
        self.token = user.generate_jwt
      rescue ServiceActor::Failure => e
        fail!(error: e.message)
      end

      private

      def validate_email
        if !attributes[:email].match?(URI::MailTo::EMAIL_REGEXP)
          fail!(error: "Formato de email inválido")
        end

        if ::User.find_by(email: attributes[:email])
          fail!(error: 'Email já foi cadastrado')
        end
      end

      def validate_password
        if attributes[:password].blank? || !attributes[:password].length.between?(3, 25)
          fail!(error: 'Senha Inválida')
        end
      end

      def validate_first_name
        if attributes[:first_name].blank? || !attributes[:first_name].length.between?(3, 25)
          fail!(error: "Nome em branco")
        end
      end

      def validate_last_name
        if attributes[:last_name].blank? || !attributes[:last_name].length.between?(3, 25)
          fail!(error: "Sobrenome em branco")
        end
      end
    end
  end
end
