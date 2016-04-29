require 'mechanize'
require './lib/request_builder.rb'
require 'json'

class Crawler
  DATE_FORMAT = 'dd/mm/yyyy'

  def crawl(params)  
    $stdout = STDOUT
    lang = 'fr'
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
        result[:emptyImg] = ad.at('.image').search('img').first['src'].include? 'placeholder' # Title with placeholder = theres no image 
        result[:price] = fetchPrice(ad)
        result[:url] = BASE_URL.chomp('/') + ad.at('a.title')['href']
        result[:title] = ad.at('a.title').content.strip
        result[:location] = fetchLocation(ad)
        result[:date] = fetchDate(ad)
        result[:details] = fetchDetails(ad)
        result[:description] = ad.at('.description').content.strip
        #puts "    url:#{url}, title:#{result[:title]}, location:#{result[:location]}, hasImage:#{!result[:emptyImg]}, price:#{result[:price]}, date:#{result[:date]}"
        $stdout.puts result.to_json
      end

      hasNext = page.at("//a[@title='Next']")
    end
  end

  def fetchDetails(ad)
    details = ad.at('.details').content.strip
    if details.include? '|' # It must be a car
      return details.split('|').map { |str| str.strip }
    end

    return nil
  end

  def fetchPrice(ad) 
    price = ad.at('.price').content.strip
    if price.include? '$'
      return price.slice(0...(price.index('.'))).gsub("\u00A0", "").tr(",$", '').to_i # 0 to first . and remove nbsp, comma and dollar sign
    end

    return nil
  end

  def fetchDate(ad)
    posted = ad.at('.date-posted').to_s
    if posted.downcase.include? 'yesterday'
      yesterday = Date.today - 1
      return {:day => yesterday.day, :month => yesterday.month, :year => yesterday.year}
    elsif posted.count('/') >= 2 # Date format in english has 2 slashes (and maybe theres a 3rd from the title
      date = ad.at(".date-posted").content.strip.slice(0...DATE_FORMAT.length)
      arr = [:day, :month, :year].zip(date.split('/')) # Merge the array of keys to the date values
      return Hash[arr.map { |k, v| [k, v.to_i] }] # Return them into a hash with values as integers
    end

    now = Date.today
    return {:day => now.day, :month => now.month, :year => now.year}
  end

  def fetchLocation(ad)
    location = ad.at('.location').content.strip
    if location.downcase.include? 'yesterday'
      return location[0...(location.length - 'yesterday'.length)].strip # Remove the date represented as "Yesterday"
    else
      return location[0...(location.length - DATE_FORMAT.length)].strip # Remove the date from the location node
    end
  end
end
