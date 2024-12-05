# frozen_string_literal: true

module ErrorHandler
  extend ActiveSupport::Concern
  included do
    rescue_from StandardError, with: :handler_method
  end

  private
    def handler_method(exception)
      case exception
        when ActiveRecord::RecordNotFound
          record_not_found_handler
        when ActiveRecord::RecordInvalid
          record_invalid_handler(exception)
        else
          generic_handler(exception)
      end
    end

    def record_not_found_handler
      render json: { error: "Record not found" }, status: 404
    end

    def record_invalid_handler(exception)
      render json: { errors: exception.record.errors }, status: 422
    end

    def generic_handler(exception)
      record = exception.try(:record)

      if record.present?
        render json: { errors: exception.record.errors }, status: 400
      else
        render json: { error: exception.message }, status: 400
      end
    end
end
