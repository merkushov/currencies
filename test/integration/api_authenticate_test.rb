require 'test_helper'

class ApiAuthenticateTest < ActionDispatch::IntegrationTest
  test "test_access_granted" do
    authorization = ActionController::HttpAuthentication::Token.encode_credentials(
      Rails.application.config.api_common_token)

    get "/api/currencies",
      params: { date: "2020-01-22" },
      headers: { 'HTTP_AUTHORIZATION' => authorization }
    assert_equal 200, status, "200 Success"

    get "/api/currency/USD",
      params: { date: "2020-01-23" },
      headers: { 'HTTP_AUTHORIZATION' => authorization }
    assert_equal 200, status, "200 Success"

    # nonexistent data
    get "/api/currencies",
      params: { date: "2000-01-01" },
      headers: { 'HTTP_AUTHORIZATION' => authorization }
    assert_equal 404, status, "404 Not found"
  end

  test "test_access_denied" do
    authorization = ActionController::HttpAuthentication::Token.encode_credentials('fake-autotest')
    
    get "/api/currencies",
      params: { date: "2020-01-22" },
      headers: { 'HTTP_AUTHORIZATION' => authorization }
    assert_equal 401, status, "401 Unauthorized"

    get "/api/currency/USD",
      headers: { 'HTTP_AUTHORIZATION' => authorization }
    assert_equal 401, status, "401 Unauthorized"

    # nonexistent data
    get "/api/currencies",
      params: { date: "2000-01-01" },
      headers: { 'HTTP_AUTHORIZATION' => authorization }
    assert_equal 401, status, "401 Unauthorized"
  end
end
