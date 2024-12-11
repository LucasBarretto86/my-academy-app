# frozen_string_literal: true

class SessionSerializer < ActiveModel::Serializer
  attributes :logged_at

  belongs_to :user
end
