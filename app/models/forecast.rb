class Forecast < ApplicationRecord


  def find_and_save_forecast(location)
    #NOTE: There is a limit to how many requests can be made
    # Test will fail when response is
    #   <Net::HTTPTooManyRequests 429 Too Many Requests readbody=true>
    # Specifically, the plan includes:
    #
    #    500 requests per day
    #
    #     25 requests per hour
    #
    #     3 requests per second


    require 'uri'
    require 'net/http'

    #location would need to be collected from the data entered by the user. Ideally they would enter a city,state
    # and this program would use an API to retrieve the latitude and longitude needed by the
    # weather API

    # just stub a location for now lat,long for Aiken, SC
    if location.blank?
      location = [33.566574, -81.719398]
    end


    static_url = URI("https://api.tomorrow.io/v4/weather/forecast?location=33.566574,-81.719398&apikey=wGr1PdeMGQzCZBNFpJItrdoOQANlEkzY")
    url = URI("https://api.tomorrow.io/v4/weather/forecast?location=" + location[0].to_s + "," + location[1].to_s + "&apikey=wGr1PdeMGQzCZBNFpJItrdoOQANlEkzY")

    #puts "url: " + url.inspect
    #puts "built_url: " + built_url.inspect
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)

    response = http.request(request)
    #puts response.inspect
    if response.message.include?("Too Many Requests")
      raise "Evaluation API access::Too many requests error, please try again later"
    else
      hash_response = JSON.parse response.body.gsub('=>', ':')
      puts hash_response.inspect
      puts hash_response["timelines"]["minutely"][0]["time"].inspect rescue puts "no time"
      puts hash_response["timelines"]["minutely"][0]["values"]["temperature"].inspect rescue puts "no temperature"
      time = hash_response["timelines"]["minutely"][0]["time"]
      temperature = hash_response["timelines"]["minutely"][0]["values"]["temperature"]
      forecast = Forecast.create(location:location.to_s,temperature: temperature.to_s, last_refreshed: time )
      forecast.save
      return [:time => time, :temperature => temperature]
    end




  end



end
