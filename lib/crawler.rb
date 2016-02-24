require 'mechanize'
require './lib/request_builder.rb'

def crawl(params)
  
  params[:page] = 1
  mechanize = Mechanize.new
  url = build_url(params)
  page = mechanize.get(url)
  
  puts "Starting search for " + url
  page.search('td.description').each do |description|
    p description.at('a.title').content
  end

end
