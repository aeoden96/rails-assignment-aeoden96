module OpenWeatherMap
  # Resolver class to resolve city id
  class Resolver
    def self.city_id(city_name)
      city_ids = JSON.parse(File.read(File.expand_path('city_ids.json', __dir__)))
      (city_ids.find { |city| city['name'] == city_name })&.fetch('id')
    end
  end
end
