require 'mechanize'
require './lib/request_builder.rb'

class Crawler
  DATE_FORMAT = 'dd/mm/yyyy'

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
      resultCount = page.search('.highlight').first.content.strip.tr('()', '').split(' ').last
      lang = "en" if page.search('body').first['class'].include? "en"
      puts "\nLANG = #{lang}"
      puts "Fetching page #{params[:page]}" 
      puts "UTD Result count = #{resultCount}"
      page.search('.regular-ad').each do |ad| 
        result[:emptyImg] = ad.at('.image').search('img').first['src'].include? "placeholder" # Title with placeholder = theres no image 
        result[:price] = fetchPrice(ad)
        result[:url] = BASE_URL.chomp('/') + ad.at('a.title')['href']
        result[:title] = ad.at('a.title').content.strip
        result[:location] = fetchLocation(ad)
        result[:date] = fetchDate(ad)
        result[:details] = fetchDetails(ad)
        result[:description] = ad.at('.description').search('p').first.content.strip
        #puts "    url:#{url}, title:#{result[:title]}, location:#{result[:location]}, hasImage:#{!result[:emptyImg]}, price:#{result[:price]}, date:#{result[:date]}"
        pp result
      end

      hasNext = page.at("//a[@title='Next']")
    end
  end

  def fetchDetails(ad)
    details = ad.at('.details').content.strip
    if details.include? '|' # It must be a car
      return details.split('|')
    end

    return nil
  end

  def fetchPrice(ad) 
    price = ad.at('.price').content.strip
    if price.include? "$"
      return price.slice(0...(price.index('.'))).gsub("\u00A0", "").tr(",$", '').to_i # 0 to first . and remove nbsp, comma and dollar sign
    end

    return nil
  end

  def fetchDate(ad)
    if ad.at('.posted').to_s.include? '<br>'
      date = ad.at(".posted").content.strip.slice(0...DATE_FORMAT.length)
      arr = [:day, :month, :year].zip(date.split('/')) # Merge the array of keys to the date values
      return Hash[arr.map {|k, v| [k, v.to_i]}] # Return them into a hash with values as integers
    end

    now = Date.today
    return {:day => now.day, :month => now.month, :year => now.year}
  end

  def fetchLocation(ad)
    location = ad.at('.posted').content.strip
    if ad.at('.posted').to_s.include? '<br>'
      return location.slice((DATE_FORMAT.length+1)...location.length).strip
    end
  
    return location
  end
end
