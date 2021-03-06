module ExceptionHandler
  extend ActiveSupport::Concern

  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end
  class ExpiredSignature < StandardError; end
  class AuthenticationError < StandardError; end

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({message: e.message}, :not_found)
    end

    rescue_from ActiveRecord::RecordInvalid ,with: :four_twenty_two
    rescue_from ExceptionHandler::MissingToken ,with: :four_twenty_two
    rescue_from ExceptionHandler::InvalidToken ,with: :four_twenty_two
    rescue_from ExceptionHandler::ExpiredSignature ,with: :four_twenty_two
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request

  end

  private

  # JSON response with message; Status code 422 - unprocessable entity
  def four_twenty_two(e)
    # e.record.errors.messages.to_json
    json_response({message: e.message}, :unprocessable_entity)
  end

  # JSON response with message; Status code 401 - Unauthorized
  def unauthorized_request(e)
    json_response({message: e.message}, :unauthorized)
  end
end