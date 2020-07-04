require 'bundler/setup'
Bundler.require

require 'dotenv/load'
require 'logger'
require 'open-uri'
require 'erb'
require 'time'
require 'json'

logger = Logger.new(STDOUT)

HOME_LAT = ENV["HOME_LAT"]
HOME_LON = ENV["HOME_LON"]
HOME_ID = ENV["HOME_ID"]
OPEN_WEATHER_API_KEY = ENV["OPEN_WEATHER_API_KEY"]

UNITS = 'imperial'

def generateBaseRequest(baseUrl)
    if HOME_ID and not HOME_ID.strip.empty?
        return "#{baseUrl}?id=#{HOME_ID}"
    else
        return "#{baseUrl}?lat=#{HOME_LAT}&lon=#{HOME_LON}"
    end
end

def generateAPICall(type)
    baseUrl = "https://api.openweathermap.org/data/2.5"

    if type == 'weather'
        baseRequest = generateBaseRequest("#{baseUrl}/weather")
        baseRequest = "#{baseRequest}&units=#{UNITS}"
        return "#{baseRequest}&appid=#{OPEN_WEATHER_API_KEY}"

    elsif type == 'forecast'
        now = Time.now.to_i + 86400 # Epoch Time - 24 hours from now
        baseRequest = generateBaseRequest("#{baseUrl}/forecast")
        baseRequest = "#{baseRequest}&units=#{UNITS}"
        return "#{baseRequest}&appid=#{OPEN_WEATHER_API_KEY}&date=#{now}"
    end
end

logger.info('Server setting up')

get '/' do
  weatherRequest = generateAPICall('weather')
  forecastRequest = generateAPICall('forecast')

  logger.debug "Weather Request API: #{weatherRequest}"
  logger.debug "Forecast Request API: #{forecastRequest}"

  tries = 0

  begin
    tries += 1
    logger.info('Requesting weather data now')
    weather_json = open(weatherRequest).read
    forecast_json = open(forecastRequest).read
  rescue => e
    logger.warn('Issue with attempting to get weather data')
    logger.warn(e)

    logger.warn('Retring now')
    # sometimes the api returns bad data :-/
    sleep 60 # Sleep for 1 minute before trying again
    retry unless tries > 5 # retried at least 5 times
  end

  @weather = JSON.parse(weather_json)
  @forecast = JSON.parse(forecast_json)
  logger.info(@forecast['list'].first['main'])

  # @weather sunset/sunrise values are passed based on UTC timestamps
  # @weather['timezone'] offsets (in seconds) against the sunset/sunrise values
  @sunrise = Time.at(@weather['sys']['sunrise'] + @weather['timezone']).utc
  @sunset = Time.at(@weather['sys']['sunset'] + @weather['timezone']).utc
  erb :home
end
