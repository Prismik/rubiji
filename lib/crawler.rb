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
    noImage = false
    title = ""
    puts "Fetching page #{params[:page]}" 
    page.search('.regular-ad').each do |ad| 
      noImage = ad.at('img')['src'].include? "placeholder" # Title with placeholder = theres no image 
      title = ad.at('a.title').content.tr('\n', '').strip
      p "page:#{params[:page]}, title:#{title}, hasImage:#{!noImage}"
    end

    hasNext = page.at("//a[@title='Suivante']")
  end
end
