#!/usr/bin/ruby

require './lib/crawler.rb'
require 'ostruct'
require 'optparse'

options = OpenStruct.new
options.location = 9001

opt_parser = OptionParser.new do |opt|
  opt.banner = 'Usage: main.rb [options]'
  opt.separator ''
  opt.separator 'Options'

  opt.on('-k', '--keywords Keywords', Array,
         'The keywords for the search separated by comma') do |keywords|
    options.keywords = keywords
  end

  opt.on('-l', '--location [Locations]', OptionParser::DecimalInteger,
         'The location of the search') do |loc|
    options.location = loc
  end

  opt.on_tail('-h', '--help', 'Show this message') do
    puts opt
    exit
  end
end.parse!

Crawler.new.crawl({
  :location => options.location,
  :keywords => options.keywords
})
