# frozen_string_literal: true

class Session < ApplicationRecord
  belongs_to :user

  validates :auth_token, :accessed_at, presence: true
end

# == Schema Information
#
# Table name: sessions
#
#  id          :integer          not null, primary key
#  accessed_at :datetime         not null
#  auth_token  :string           default(""), not null
#  expired     :boolean          default(FALSE), not null
#  ip_address  :string           default("")
#  tos         :boolean          default(FALSE), not null
#  user_agent  :string           default("")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer          not null
#
# Indexes
#
#  index_sessions_on_user_id  (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
