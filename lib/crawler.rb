require 'mechanize'
require './lib/request_builder.rb'

def crawl(params)  
  lang = "fr"
  mechanize = Mechanize.new
 
  params[:page] = 0
  hasNext = true 
  
  while hasNext
    result = Hash.new
    params[:page] = params[:page] + 1  
    result[:page] = params[:page]
    url = build_url(params)
    page = mechanize.get(url)
    lang = "en" if page.search('body').first['class'].include? "en"
    puts "LANG = #{lang}"
    puts "Fetching page #{params[:page]}" 
    page.search('.regular-ad').each do |ad| 
      result[:emptyImg] = ad.at('img')['src'].include? "placeholder" # Title with placeholder = theres no image 
      result[:price] = fetchPrice(ad)
      result[:title] = ad.at('a.title').content.tr('\n', '').strip
      puts "    title:#{result[:title]}, hasImage:#{!result[:emptyImg]}, price:#{result[:price]}"
    end

    hasNext = page.at("//a[@title='Suivante']")
  end
end

def fetchPrice(ad) 
      price = ad.at('.price').content.strip
      if price.include? "$"
        return price.slice(0...(price.index(','))).gsub("\u00A0", "").to_i # Remove nbsp 
      end

      return nil
end

def fetchDate(ad)
  date = ad.at('.posted').content.strip
  if date.include? "-"
Date.strptime(date, "%d, %m, %a }")
  end
end
