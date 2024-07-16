module OpenWeatherMap
  # City class
  class City
    attr_reader :id, :lat, :lon, :name

    def initialize(id:, lat:, lon:, name:, temp_k:)
      @id = id
      @lat = lat
      @lon = lon
      @name = name
      @temp_k = temp_k
    end

    def temp
      (@temp_k - 273.15).round(2)
    end

    def nearby(count: 5)
      OpenWeatherMap.nearby(lat, lon, count)
    end

    def coldest_nearby(count: 5)
      nearby(count: count).min
    end

    def <=>(other)
      if temp == other.temp
        name <=> other.name
      else
        temp <=> other.temp
      end
    end

    def self.parse(city)
      new(
        id: city['id'],
        name: city['name'],
        lat: city['coord']['lat'],
        lon: city['coord']['lon'],
        temp_k: city['main']['temp']
      )
    end
  end
end
