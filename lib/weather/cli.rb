# encoding: UTF-8

module Weather
  class CLI
    BASE_MAPPINGS = {
      chanceflurries: "~❅",
      chancerain: "~☔",
      chancesleet: "~❆",
      chancesnow: "~❆",
      chancetstorms: "~☈",
      clear: "☼",
      cloudy: "☁",
      flurries: "❆",
      fog: "♒",
      hazy: "♒",
      mostlycloudy: "☁",
      mostlysunny: "☀",
      partlycloudy: "-☁",
      partlysunny: "-☀",
      rain: "☔",
      sleet: "❆",
      snow: "❆",
      sunny: "☼",
      tstorms: "☈"
    }

    ICON_MAPPINGS = BASE_MAPPINGS.inject({}) do |memo, arr|
      memo[arr[0]] = arr[1]
      memo["nt_#{arr[0]}".to_sym] = arr[1]
      memo
    end

    def initialize(num_periods = 8)
      @config ||= Weather::Config.new
    end

    def forecast_icons
      icons = []
      conditions_request = open(construct_forecast_url)
      json_response = JSON.load conditions_request
      json_response['forecast']['txt_forecast']['forecastday'].collect do |forecast|
        icons << ICON_MAPPINGS[forecast['icon'].to_sym]
        if forecast['title'].match /night/i
          icons << ' '
        end
      end
      icons
    end

    private

    def construct_forecast_url
      "http://api.wunderground.com/api/#{@config.api_key}/forecast/q/#{@config.state}/#{@config.city}.json"
    end
  end
end
