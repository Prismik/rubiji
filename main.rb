#!/usr/bin/ruby

require './lib/crawler.rb'

crawl({
  :location => 9001,
  :keywords => ['honda', 'civic']
})
