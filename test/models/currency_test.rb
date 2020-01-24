require 'test_helper'

class CurrencyTest < ActiveSupport::TestCase
  test "successful save" do
    currency = currencies(:one)

    obj = Currency.new(
      code: currency.code,
      name: currency.name,
      rate: currency.rate,
      measure_date: '2000-01-01',
    )
    assert obj.save, "Saved successfuly"

    assert_equal 1, Currency.where(
      code: currency.code,
      measure_date: '2000-01-01'
    ).count, "The record is in the database"
  end

  test "should not save article without required fields" do
    obj = Currency.new
    assert_not obj.save,
      "Saved the currency unsuccessful without a code and name"
  end
end
