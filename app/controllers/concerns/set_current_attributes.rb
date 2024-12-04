# frozen_string_literal: true

module SetCurrentAttributes
  extend ActiveSupport::Concern

  included do
    prepend_before_action :set_current_attributes
  end

  private
    def set_current_attributes
      Current.request_id = request.uuid
      Current.user_agent = request.user_agent
      Current.ip_address = request.ip
      Current.request = request
      Current.token = request.headers["Authorization"]&.split(" ")&.last
    end
end
