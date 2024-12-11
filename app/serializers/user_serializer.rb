# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :full_name, :email, :admin

  def full_name
    [object.name, object.surname].compact_blank.join(" ")
  end
end
