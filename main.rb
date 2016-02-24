#!/usr/bin/ruby

require './lib/crawler.rb'

crawl({
  :location => 9001,
  :keywords => ['imac', '2014']
})
