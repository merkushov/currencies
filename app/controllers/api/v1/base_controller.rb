class Api::V1::BaseController < ActionController::API
  # before_action :restrict_access
  # respond_to :json

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  # protected

  # def request_http_token_authentication(realm = "Application")
  #   self.headers["WWW-Authenticate"] = %(Token realm="#{realm.gsub(/"/, "")}")
  #   render :json => {:error => "HTTP Token: Access denied."}, :status => :unauthorized
  # end

  # private

  # def restrict_access
  #   http_auth_header_content
  #   authenticate_or_request_with_http_token do |token, options|
  #     ApiKey.exists?(access_token: token) || User.exists?(auth_token: token)
  #   end
  # end

  # def http_auth_header_content
  #   return @http_auth_header_content ||= begin
  #     if request.headers['Authorization'].present?
  #       pattern = /^Bearer /
  #       header  = request.headers["Authorization"]
  #       request.headers["Authorization"] = "Token token=#{header.gsub(pattern, '')}" if header && header.match(pattern)
  #     else
  #       nil
  #     end
  #   end
  # end

  def record_not_found
    render :json => {:error => "Not Found"}, :status => :not_found
  end
end