require 'net/http'
require 'json'
require 'date'

desc "Get daily exchange rates from the CBR"
task :fetch_cbr_daily_exchange_rate => :environment do
  uri       = URI('http://cbr.ru/scripts/XML_daily.asp')
  response  = Net::HTTP.get(uri)
  cbr_rates = Hash.from_xml(response)

  measure_date = Date.today.to_date
  if cbr_rates["ValCurs"] and cbr_rates["ValCurs"]["Date"]
    measure_date = Date.strptime(cbr_rates["ValCurs"]["Date"],"%d.%m.%Y").to_date
  end

  for item in cbr_rates["ValCurs"]["Valute"] do

    rate = item["Value"].tr(',','.').to_f

    measure_record = Currency.find_by(
      code: item["CharCode"],
      measure_date: measure_date,
    )

    if measure_record
      if measure_record.rate != rate
        measure_record.update( rate: rate )
      end
    else
      Currency.create(
        code: item["CharCode"],
        name: item["Name"],
        rate: rate,
        measure_date: measure_date,
      )
    end
  end
end
