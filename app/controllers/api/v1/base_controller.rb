class Api::V1::BaseController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :api_authenticate

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  private

  def api_authenticate
    authenticate_or_request_with_http_token do |token, options|
      ActiveSupport::SecurityUtils.secure_compare(
        token, Rails.application.config.api_common_token)
    end
  end

  def record_not_found
    render :json => {:error => "Not Found"}, :status => :not_found
  end
end