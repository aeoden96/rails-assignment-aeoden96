# frozen_string_literal: true

# Description: This module is responsible for fetching the weather data from the OpenWeatherMap API.
module OpenWeatherMap
  URL = 'https://api.openweathermap.org/data/2.5/weather'

  def self.city(city_name)
    city_id = OpenWeatherMap::Resolver.city_id(city_name)
    return nil if city_id.nil?

    response = fetch_weather_data(city_id)
    handle_response(response)
  end

  private

  private_class_method def self.fetch_weather_data(city_id)
    HTTParty.get("#{URL}?id=#{city_id}&appid=#{Rails.application.credentials.open_weather_map_api_key}")
  end

  private_class_method def self.handle_response(response)
    case response.code
    when 200
      City.parse(response.parsed_response)
    when 401
      raise 'Invalid API key'
    when 404
      nil
    else
      raise "Unexpected response code: #{response.code}"
    end
  end
end
