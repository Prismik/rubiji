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
    page.search('.regular-ad').each do |ad| 
      params[:emptyImg] = ad.at('img')['src'].include? "placeholder" # Title with placeholder = theres no image 
      params[:title] = ad.at('a.title').content.tr('\n', '').strip
      puts "    title:#{params[:title]}, hasImage:#{!params[:emptyImg]}"
    end

    hasNext = page.at("//a[@title='Suivante']")
  end
end
