# frozen_string_literal: true

class SessionSerializer < ActiveModel::Serializer
  attributes :logged_at

  belongs_to :user
end

# == Schema Information
#
# Table name: sessions
#
#  id         :integer          not null, primary key
#  expires_at :datetime         not null
#  ip_address :string           default("")
#  logged_at  :datetime         not null
#  token      :string           default(""), not null
#  user_agent :string           default("")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_sessions_on_token                   (token)
#  index_sessions_on_user_id                 (user_id)
#  index_sessions_on_user_id_and_expires_at  (user_id,expires_at)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
