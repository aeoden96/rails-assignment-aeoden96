require 'rails_helper'
require 'open_weather_map/city'

RSpec.describe OpenWeatherMap::City do
  zagreb = described_class.new(id: 1234, lat: 89.312, lon: 12.123, name: 'Zagreb', temp_k: 300)
  zagreb2 = described_class.new(id: 1234, lat: 89.312, lon: 12.123, name: 'Zagreb',
                                temp_k: 300)
  samobor = described_class.new(id: 1234, lat: 89.312, lon: 12.123, name: 'Samobor',
                                temp_k: 200)
  sisak = described_class.new(id: 1234, lat: 89.312, lon: 12.123, name: 'Sisak', temp_k: 300)

  res = {
    'id' => 1234,
    'coord' => {
      'lat' => 89.312,
      'lon' => 12.123
    },
    'name' => 'Zagreb',
    'main' => {
      'temp' => 300
    }
  }

  describe 'properties' do
    it 'attributes are set correctly' do
      expect(zagreb.id).to eq(1234)
      expect(zagreb.lat).to eq(89.312)
      expect(zagreb.lon).to eq(12.123)
      expect(zagreb.name).to eq('Zagreb')
    end

    it 'converts temperature correctly' do
      expect(zagreb.temp).to eq(26.85)
    end
  end

  describe 'comparison' do
    it 'the receiver has a lower temperature than the other object' do
      expect(samobor <=> zagreb).to eq(-1)
    end

    it 'receiver has the same temp as other, but the receiver name comes first alphabetically' do
      expect(sisak <=> zagreb).to eq(-1)
    end

    it 'receiver has the same temperature and name as the other object' do
      expect(zagreb <=> zagreb2).to eq(0)
    end

    it 'receiver has a higher temperature than the other object' do
      expect(zagreb <=> samobor).to eq(1)
    end

    it 'receiver has the same temp as other, but the receiver name comes second alphabetically' do
      expect(zagreb <=> sisak).to eq(1)
    end
  end

  describe 'parse API response' do
    it 'parses the API response correctly' do
      city = described_class.parse(res)
      expect(city.id).to eq(1234)
      expect(city.lat).to eq(89.312)
      expect(city.lon).to eq(12.123)
      expect(city.name).to eq('Zagreb')
      expect(city.temp).to eq(26.85)
    end
  end
end
