# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  validates :name, :surname, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end