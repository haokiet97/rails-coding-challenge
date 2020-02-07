# encoding: utf-8

module CurrencyHelper

  # options[:cents] => true : format the number with 2 decimal places
  # options[:cents] => false : ommit cents (default)
  # options[:symbol] => false : ommit the dollar sign
  # options[:currency] : currency code to format with

  def format_currency (cents, options = {  })
    CurrencyFormatter.new(options[:currency] || default_currency).format(cents, options)
  end

  def format_currency_full (cents)
    format_currency(cents, cents: true, thousands: true)
  end

  def currency_symbol (currency)
    CurrencyFormatter.new.symbol(currency)
  end

  def default_currency
    "$"
  end

end
