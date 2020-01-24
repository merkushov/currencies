require 'test_helper'
# require 'json'

class Api::V1::CurrenciesControllerTest < ActionDispatch::IntegrationTest
  test "check /api/currencies" do
    authorization = ActionController::HttpAuthentication::Token.encode_credentials(
      Rails.application.config.api_common_token)

    get '/api/currencies',
      headers: { 'HTTP_AUTHORIZATION' => authorization }
    assert_equal 404, status, "404 NotFound (no data for current date)"

    currency = currencies(:one)
    get '/api/currencies', params: { date: currency.measure_date.to_s },
      headers: { 'HTTP_AUTHORIZATION' => authorization }
    assert_equal 200, status, "200 OK"
    assert_equal 3, response.parsed_body.length, "3 items in response"

    currency = currencies(:four)
    get '/api/currencies', params: { date: currency.measure_date.to_s },
      headers: { 'HTTP_AUTHORIZATION' => authorization }
    assert_equal 200, status, "200 OK"
    assert_equal 10, response.parsed_body.length, "10 items in response"
  end

  test "check /api/currencies paging" do
    authorization = ActionController::HttpAuthentication::Token.encode_credentials(
      Rails.application.config.api_common_token)

    currency = currencies(:four)
    measure_date = currency.measure_date.to_s

    # Comparison of content for parameters page=1 and 'no page'
    get '/api/currencies', params: { date: measure_date },
      headers: { 'HTTP_AUTHORIZATION' => authorization }
    assert_equal 200, status, "200 OK"
    assert_equal 10, response.parsed_body.length, "10 items in response"

    content_without_page = response.body

    get '/api/currencies', params: { page: 1, date: measure_date },
      headers: { 'HTTP_AUTHORIZATION' => authorization }
    assert_equal 200, status, "200 OK"
    assert_equal 10, response.parsed_body.length, "10 items in response"

    content_with_page_1 = response.body

    assert_equal content_without_page, content_with_page_1,
      "response body is the same for page=1 and 'no page'"

    # Checking Page 2
    get '/api/currencies', params: { page: 2, date: measure_date },
      headers: { 'HTTP_AUTHORIZATION' => authorization }
    assert_equal 200, status, "200 OK"
    assert_equal 2, response.parsed_body.length, "2 items in response"

    content_with_page_2 = response.body

    assert_not_equal content_with_page_1, content_with_page_2,
      "response body is not equal for page=1 and page=2"

    # Checking Page 3 (there is no data)
    get '/api/currencies', params: { page: 3, date: measure_date },
      headers: { 'HTTP_AUTHORIZATION' => authorization }
    assert_equal 404, status, "404 NotFound"
  end

  test "check /api/currency" do
    authorization = ActionController::HttpAuthentication::Token.encode_credentials(
      Rails.application.config.api_common_token)

    currency = currencies(:one)
    measure_date = currency.measure_date.to_s

    get '/api/currency/' + currency.code.to_s, params: { date: measure_date },
      headers: { 'HTTP_AUTHORIZATION' => authorization }
    assert_equal 200, status, "200 OK"
    assert_equal Hash, response.parsed_body.class, "Response is a Hash"

    assert_equal currency.rate.to_s, response.parsed_body["rate"],
      "Rate as expected"

    get '/api/currency/FAKE', params: { date: measure_date },
      headers: { 'HTTP_AUTHORIZATION' => authorization }
    assert_equal 404, status, "404 NotFound"

    # get '/api/currency', params: { date: measure_date },
    #   headers: { 'HTTP_AUTHORIZATION' => authorization }
    # assert_equal 404, status, "404 NotFound"
  end
end
