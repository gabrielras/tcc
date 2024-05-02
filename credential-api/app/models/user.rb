class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, allow_nil: true

  has_many :roles, dependent: :destroy
  has_many :institutions, through: :roles

  validates :first_name, presence: true, length: { in: 3..25 }
  validates :last_name, presence: true, length: { in: 3..25 }

  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true

  def generate_jwt
    JWT.encode({ user_id: id }, Rails.application.secrets.secret_key_base)
  end

  def generate_code
    self.update!(code_password: SecureRandom.hex(3))
    UserMailer.with(self).send_code_password.deliver_later
  end
end
