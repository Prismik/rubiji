#!/usr/bin/ruby

require 'pp'
require 'json'
require 'date'

def did_pass_filter(ad, filter)
  price = ad['price'].to_i
  tempDate = ad['date']
  date = Date.new(tempDate['year'], tempDate['month'], tempDate['day'])
  return price != nil && price <= filter[:price][:max] && price >= filter[:price][:min] && (date + filter[:age]) >= Date.today && ad['emptyImage'] != filter[:image]
end

filter = Hash.new
filter[:price] = { :min => 250, :max => 900 }
filter[:age] = 325
filter[:image] = true

$stdin.each_line do |line|
  begin
    ad = JSON.parse(line)
    if did_pass_filter(ad, filter)
      $stdout.puts ad
    end
  rescue JSON::ParserError => e
    #puts "======> Cannot parse ad\n"  
  end
end
