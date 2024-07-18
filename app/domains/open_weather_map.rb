module OpenWeatherMap
  module OpenWeatherMapApi
    URL = 'https://api.openweathermap.org/data/2.5/'

    private_class_method def self.appid
      Rails.application.credentials.open_weather_map_api_key
    end

    private_class_method def self.get(city_params)
      HTTParty.get("#{URL}#{city_params}&appid=#{appid}")
    end

    def self.fetch_city(city_id)
      get("weather?id=#{city_id}")
    end

    def self.fetch_cities(city_ids)
      get("group?id=#{city_ids}")
    end

    def self.fetch_nearby(lat, lon, count)
      get("find?lat=#{lat}&lon=#{lon}&cnt=#{count}")
    end
  end

  def self.city(city_name)
    city_id = OpenWeatherMap::Resolver.city_id(city_name)
    return nil if city_id.nil?

    handle_response(OpenWeatherMapApi.fetch_city(city_id))
  end

  def self.cities(city_names)
    handle_response(OpenWeatherMapApi.fetch_cities(resolve_ids(city_names).join(',')),
                    multiple: true)
  end

  def self.nearby(lat, lon, count)
    handle_response(OpenWeatherMapApi.fetch_nearby(lat, lon, count), multiple: true)
  end

  private_class_method def self.resolve_id(city_name)
    OpenWeatherMap::Resolver.city_id(city_name)
  end

  private_class_method def self.resolve_ids(city_names)
    city_names.map(&method(:resolve_id)).compact
  end

  private_class_method def self.parse_list(city_list)
    city_list['list'].map do |city_data|
      OpenWeatherMap::City.parse(city_data)
    end
  end

  private_class_method def self.handle_response(response, multiple: false)
    case response.code
    when 200
      handle_ok_response(response, multiple: multiple)
    when 401
      raise 'Invalid API key'
    when 404
      nil
    else
      raise "Unexpected response code: #{response.code}"
    end
  end

  private_class_method def self.handle_ok_response(response, multiple: false)
    if multiple
      parse_list(response.parsed_response)
    else
      OpenWeatherMap::City.parse(response.parsed_response)
    end
  end
end
