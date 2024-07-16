# frozen_string_literal: true

# Description: This module is responsible for fetching the weather data from the OpenWeatherMap API.
module OpenWeatherMap
  URL = 'https://api.openweathermap.org/data/2.5/'

  def self.city(city_name)
    city_id = OpenWeatherMap::Resolver.city_id(city_name)
    return nil if city_id.nil?

    handle_response(fetch_weather_data(city_id))
  end

  def self.cities(city_names)
    handle_response(fetch_multiple_weather_data(resolve_ids(city_names)), multiple: true)
  end

  private

  private_class_method def self.resolve_id(city_name)
    OpenWeatherMap::Resolver.city_id(city_name)
  end

  private_class_method def self.resolve_ids(city_names)
    city_names.map(&method(:resolve_id)).compact
  end

  private_class_method def self.fetch_weather_data(city_id)
    get(city_id)
  end

  private_class_method def self.fetch_multiple_weather_data(city_ids)
    get(city_ids.join(','), multiple: true)
  end

  private_class_method def self.get(city_params, multiple: false)
    HTTParty.get("#{URL}#{multiple ? 'group' : 'weather'}?id=#{city_params}&appid=#{appid}")
  end

  private_class_method def self.appid
    Rails.application.credentials.open_weather_map_api_key
  end

  private_class_method def self.parse_list(city_list)
    city_list['list'].map do |city_data|
      OpenWeatherMap::City.parse(city_data)
    end
  end

  private_class_method def self.handle_response(response, multiple: false)
    case response.code
    when 200
      multiple ? parse_list(response.parsed_response) : OpenWeatherMap::City.parse(response.parsed_response)
    when 401
      raise 'Invalid API key'
    when 404
      nil
    else
      raise "Unexpected response code: #{response.code}"
    end
  end
end
