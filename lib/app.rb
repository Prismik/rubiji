require './crawler.rb'
require 'sinatra'
require 'json'

set :port, 8080
set :environment, :production

get '/ads' do
  if params.has_key? 'query' 
    content_type :json
    results = { }
    results = Crawler.new.crawl({
      :location => 9001,
      :keywords => params['query'].split(' ')
    })

    return results.to_json
  else
    halt 404
  end
end
