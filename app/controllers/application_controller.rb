# frozen_string_literal: true

class ApplicationController < ActionController::API
  include SetCurrentAttributes
  include ErrorHandler
end
