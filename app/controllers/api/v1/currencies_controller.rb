require 'date'

class Api::V1::CurrenciesController < Api::V1::BaseController

  @@currencies_limit_per_page = 10

  before_action :set_measure_date, only: [:index, :show]

  def index
    page_num = params[:page] and params[:page].to_i > 0 ? params[:page].to_i : 1
    query_offset = 0
    if params[:page]
      query_offset = ( page_num.to_i - 1 ) * @@currencies_limit_per_page
    end

    rows = Currency
      .where( measure_date: @measure_date )
      .limit(@@currencies_limit_per_page)
      .offset(query_offset)

    if rows and rows.count > 0
      render json: rows
    else
      render :json => {:error => "Not Found"}, :status => :not_found
    end
  end

  def show
    currency = Currency.find_by(
      code: params[:code],
      measure_date: @measure_date
    )
    if currency
      render json: currency
    else
      render :json => {:error => "Not Found"}, :status => :not_found
    end
  end

  private
    def set_measure_date
      @measure_date = Date.today.to_date
      if params[:date]
        @measure_date = params[:date]
      end
    end

end
