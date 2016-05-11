require './crawler.rb'
require 'sinatra'
require 'json'

set :port, 8080
set :environment, :production

get '/ads' do
  results = { }
  if params.has_key? 'keywords'
    results = Crawler.new.crawl({
      :location => 9001,
      :keywords => params['keywords'].split(',')
    })
  end
  
  return results.to_json
end
