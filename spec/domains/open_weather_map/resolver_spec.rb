require 'rails_helper'
require 'open_weather_map/resolver'

RSpec.describe OpenWeatherMap::Resolver do
  describe '#city_id' do
    it 'returns the correct id for a known city' do
      expect(OpenWeatherMap::Resolver.city_id('Zagreb')).to eq(3_186_886)
    end

    it 'returns nil for missing diacritics' do
      expect(OpenWeatherMap::Resolver.city_id('Varazdin')).to be_nil
    end

    it 'returns nil when called with an unknown city name' do
      expect(OpenWeatherMap::Resolver.city_id('Some other city')).to be_nil
    end
  end
end
