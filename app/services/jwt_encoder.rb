# frozen_string_literal: true

class JWTEncoder
  JWT_SECRET_KEY = ENV["JWT_SECRET_KEY"]

  def self.encode(payload)
    JWT.encode(payload, JWT_SECRET_KEY, "HS256")
  end

  def self.decode(token)
    JWT.decode(token, JWT_SECRET_KEY)&.first
  end
end
