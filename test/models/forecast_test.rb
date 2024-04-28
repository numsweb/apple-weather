require "test_helper"

class ForecastTest < ActiveSupport::TestCase
  # note api is throttled so cannot run too many tests at one time
  # when it fails repeat the test
   test "retrieve forecast" do
     location = [33.566574, -81.719398]
     forecast = Forecast.new
     response = forecast.find_and_save_forecast(location)
     assert(response.is_a?(Array))
     assert(response[0].is_a?(Hash))
     assert(response[0].has_key?(:time))
     assert(response[0].has_key?(:temperature))
   end
end
