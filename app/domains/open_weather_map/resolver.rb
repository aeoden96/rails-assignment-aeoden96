module OpenWeatherMap
  # Resolver class to resolve city id
  class Resolver
    def city_id(city_name)
      (city_ids.find { |city| city['name'] == city_name })&.fetch('id')
    end

    private

    def city_ids
      JSON.parse(File.read(File.expand_path('city_ids.json', __dir__)))
    end
  end
end
