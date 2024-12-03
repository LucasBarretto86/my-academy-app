# frozen_string_literal: true

module RequestHelpers
  def authorize_user(user_id)
    jwt_token = JWTEncoder.encode({ user_id: user_id })
    default_headers = { "Authorization" => "Bearer #{jwt_token}" }

    allow_any_instance_of(ActionDispatch::Request).to receive(:headers).and_return(default_headers)
  end

  def response_body
    return "" unless response

    JSON.parse(response.body)
  end
end

RSpec.configure do |config|
  config.include RequestHelpers, type: :request
end
