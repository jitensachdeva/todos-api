class ApplicationController < ActionController::API

  before_action :authorize_request

  include Response
  include ExceptionHandler

  private
  def authorize_request
    @current_user = AuthorizeApiRequest.new(request.headers).call[:user]
  end
end
