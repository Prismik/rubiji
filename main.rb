#!/usr/bin/ruby

require './lib/crawler.rb'


Crawler.new.crawl({
  :location => 9001,
  :keywords => ['imac', '2014']
})
