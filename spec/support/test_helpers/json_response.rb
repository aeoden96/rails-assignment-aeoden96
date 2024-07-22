module TestHelpers
  module JsonResponse
    def json_body
      JSON.parse(response.body)
    end

    def api_headers
      {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    end

    def alternative_show_serializer_headers
      {
        'X-API-SERIALIZER': 'jsonapi'
      }
    end

    def alternative_index_serializer_headers
      {
        'X-API-SERIALIZER-ROOT': '0'
      }
    end
  end
end
