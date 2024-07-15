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

    def <=>(other)
      if temp == other.temp
        name <=> other.name
      else
        temp <=> other.temp
      end
    end
  end
end
