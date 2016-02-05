BASE_URL = "http://www.kijiji.ca/"

LOCATIONS = {
  9001 => "quebec"
}

def build_url(params)
  url = BASE_URL
  url += "b-" + LOCATIONS[params[:location]] + "/" if params.has_key?(:location)
  url += params[:keywords].join("-") + "/" if params.has_key?(:keywords)
  url += "page-#{params[:page]}/" if params.has_key?(:page)
  url += "kol#{params[:location]}" if params.has_key?(:location)

  puts url
end

build_url({
  :location => 9001,
  :keywords => ['honda', 'civic'],
  :page => 2
})
