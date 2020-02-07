class CurrencyFormatter
  
  include ActionView::Helpers::NumberHelper
  
  attr_reader :default_currency
  
  def initialize (default_currency = "$")
    @default_currency = default_currency
  end
  
  # options[:cents] => true : format the number with 2 decimal places
  # options[:cents] => false : ommit cents (default)
  # options[:symbol] => false : ommit the dollar sign
  # options[:currency] : currency code to format with

  def format (cents, options = {  })
    value = BigDecimal.new(cents || 0) / 100
    precision = (options[:cents].nil? || options[:cents] == false) ? 0 : 2
    delimiter = options[:thousands].nil? ? "" : ","
    unit = options[:symbol] == false ? "" : symbol(options[:currency])

    number_to_currency(value, {
      precision: precision,
      delimiter: delimiter,
      unit: unit
    })
  end

  def symbol (currency)
    Currency.new(currency || default_currency).symbol
  rescue StandardError => e
    "$"
  end
  
end