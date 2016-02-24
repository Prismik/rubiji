require 'mechanize'
require './lib/request_builder.rb'

def crawl(params)  
  mechanize = Mechanize.new
 
  params[:page] = 0
  hasNext = true 
  
  while hasNext
    params[:page] = params[:page] + 1  
    url = build_url(params)
    page = mechanize.get(url)

    puts "Fetching page #{params[:page]}" 
    page.search('td.description').each { |desc| p desc.at('a.title').content }

    hasNext = page.at("//a[@title='Suivante']")
  end
end
