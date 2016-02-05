#!/usr/bin/ruby

require 'mechanize'

mechanize = Mechanize.new

page = mechanize.get('http://stackoverflow.com/')

puts page.title
