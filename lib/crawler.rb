require 'mechanize'
require './lib/request_builder.rb'

def crawl(params)  
  mechanize = Mechanize.new
  
  for i in 1..100 
    params[:page] = i  
    url = build_url(params)
    page = mechanize.get(url)
    
    puts "Starting search for #{url}"
    page.search('td.description').each { |desc| p desc.at('a.title').content }
  end
end
