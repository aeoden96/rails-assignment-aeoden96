module TestHelpers
  module JsonResponse
    def json_body
      JSON.parse(response.body)
    end

    def api_headers(root: '1', serializer: nil, token: nil)
      {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-API-SERIALIZER-ROOT': root,
        'X-API-SERIALIZER': serializer,
        'Authorization': token
      }
    end
  end
end
