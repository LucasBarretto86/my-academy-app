# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :surname, :email, :admin
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
