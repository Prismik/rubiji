BASE_URL = "http://www.kijiji.ca/"

LOCATIONS = {
  "qc" => {"name" => "quebec", "code" => "9001"}
}

def build_url(params)

  url = BASE_URL

  if params.has_key?(:location)
    url += "b-" + LOCATIONS[params[:location]]["name"] + "/"
  end

  if params.has_key?(:keywords)
    url += params[:keywords].join("-") + "/"
  end

  if params.has_key?(:page)
    url += "page-#{params[:page]}/"
  end

  if params.has_key?(:location)
    url += "k0l" + LOCATIONS[params[:location]]["code"]
  end

  puts url

end

build_url({
  'location': 'qc',
  'keywords':["chatton", "doux"],
  'page': 2
})
