require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     

# enter your Dark Sky API key here
ForecastIO.api_key = "1eca092840a61ca23b114d2fe4f66f49"

url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=d078b1b3a78b455daa5931c84b137fbc"
news = HTTParty.get(url).parsed_response.to_hash
# news is now a Hash you can pretty print (pp) and parse for your output
#pp news

@headline_1 = news["articles"][2]["title"]
@headline_1_url = news["articles"][2]["url"]

# puts headline_1
# puts headline_1_url

    #"The current temperature is #{current_temp} and conditions are #{current_conditions}"
    # </div>
    

get "/" do
  # show a view that asks for the location
  view "ask"
end

get "/news" do
  # do everything else

    results = Geocoder.search(params["input"])

    @lat_long = results.first.coordinates # [lat, long] array 
    #"#{lat_long[0]} #{lat_long[1]}" #writes the lat and long points to the screen
    #"#{lat_long}"
    @lat = @lat_long[0]
    @long = @lat_long[1]
    #city = results[,display_name]   
    @forecast = ForecastIO.forecast(@lat,@long).to_hash
        
    @current_temp= @forecast ["currently"]["temperature"] #forecast is the first hash, access the hash within using [] and calling out variable you want in ""
    @current_conditions = @forecast["currently"] ["summary"]

    @headline_1 = news["articles"][2]["title"]
    @headline_1_url = news["articles"][2]["url"]

    # @daily_temp = Array.new
    # @daily_summ = Array.new

    # i=0
    # for daily in @forecast["daily"]["data"] do  #creates an array call daily
    #     @daily_temp[i] = @forecast["daily"]["temperaturHigh"]
    #     @daily_summ[i] = daily["summary"]
    #     i = i + 1
    # end


    # for day in @forecast["daily"]["data"]
    # puts "A high temperature of #{day["temperatureHigh"]} and #{day["summary"]}."
    # end

    view "news"
    #"The current temperature is #{current_temp} and conditions are #{current_conditions}"
    # # </div>
    
    # </div>
    #"In Evanston, it is currently #{current_temp} and #{current_conditions}"
    #   </div>
    #     # do the heavy lifting, use Global Hub lat/long
    #     forecast = ForecastIO.forecast(42.0574063,-87.6722787).to_hash

    #     # pp = pretty print
    #     # use instead of `puts` to make reading a hash a lot easier
    #     # e.g. `pp forecast`

    #     current_temp= forecast ["currently"]["temperature"] #forecast is the first hash, access the hash within using [] and calling out variable you want in ""
    #     current_conditions = forecast["currently"] ["summary"]

    #     puts "In Evanston, it is currently #{current_temp} and #{current_conditions}"
    #     #high_temp = forecast["daily"]["data"][0]["temperatureHigh"]
    #     #puts high_temp

    #     for daily_forecast in forecast["daily"]["data"] #creates an array call daily_forecast
    #     puts "A high temperature of #{daily_forecast["temperatureHigh"]} and #{daily_forecast["summary"]}."
    #     end
    # </div>
end