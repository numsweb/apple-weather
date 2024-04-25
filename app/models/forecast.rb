class Forecast < ApplicationRecord


  def find_and_save_forecast(location)
    #expects location (see format below)
    require 'uri'
    require 'net/http'

    #location would need to be collected from the data entered by the user.
    # just stub a location for now lat,long for Aiken, SC
    location = [33.566574, -81.719398]

    url = URI("https://api.tomorrow.io/v4/weather/forecast?location=33.566574,-81.719398&apikey=wGr1PdeMGQzCZBNFpJItrdoOQANlEkzY")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)

    response = http.request(request)

    hash_response = JSON.parse response.body.gsub('=>', ':')
    time = hash_response["timelines"].first.second[0]["time"]
    temperature = hash_response["timelines"].first.second[0]["values"]["temperature"]

    forecast = Forecast.create(location:location.to_s,temperature: temperature, last_refreshed: time )
    forecast.save
    return [:time => time, :temperature => temperature]

  end



end
