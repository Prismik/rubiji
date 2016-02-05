BASE_URL = "http://www.kijiji.ca/"

LOCATIONS = {
  9001 => "quebec"
}

def build_url(params)

  url = BASE_URL

  if params.has_key?(:location)
    url += "b-" + LOCATIONS[params[:location]] + "/"
  end

  if params.has_key?(:keywords)
    url += params[:keywords].join("-") + "/"
  end

  if params.has_key?(:page)
    url += "page-#{params[:page]}/"
  end

  if params.has_key?(:location)
    url += "k0l#{params[:location]}"
  end

  puts url

end

build_url({
  'location': 9001,
  'keywords':["honda", "civic"],
  'page': 2
})
