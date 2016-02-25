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
      result[:url] = ad.at('a.title')['url']
      result[:title] = ad.at('a.title').content.tr('\n', '').strip
      result[:date] = fetchDate(ad)
      puts "    url:#{url}, title:#{result[:title]}, hasImage:#{!result[:emptyImg]}, price:#{result[:price]}, date:#{result[:date]}"
    end

    hasNext = page.at("//a[@title='Suivante']")
  end
end

def fetchPrice(ad) 
  price = ad.at('.price').content.strip
  if price.include? "$"
    return price.slice(0...(price.index('.'))).gsub("\u00A0", "").tr(",$", '').to_i # 0 to first . and remove nbsp, comma and dollar sign
  end

  return nil
end

def fetchDate(ad)
  date = ad.at(".posted").content.strip.slice(0...10)
  if date.include? "/"
    arr = [:day, :month, :year].zip(date.split('/')) # Merge the array of keys to the date values
    return Hash[arr.map {|k, v| [k, v.to_i]}] # Return them into a hash with values as integers
  end

  now = Date.today
  return {:day => now.day, :month => now.month, :year => now.year}
end
