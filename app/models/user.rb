# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_many :sessions

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  validates_length_of :password, minimum: 8, message: "must be at least 8 characters"
end

# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  admin           :boolean          default(FALSE), not null
#  email           :string           not null
#  name            :string           default("")
#  password_digest :string           default(""), not null
#  surname         :string           default("")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
