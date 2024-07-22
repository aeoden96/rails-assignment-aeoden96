class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  def render_serializer_show(serializer, alternate_serializer, record, root)
    if request.headers['X-API-SERIALIZER'] == 'jsonapi'
      alternate_serializer.new(record).serializable_hash.to_json
    else
      serializer.render(record, view: :include_associations, root: root)
    end
  end

  def render_index_serializer(serializer, records, root)
    if request.headers['X-API-SERIALIZER-ROOT'] == '0'
      serializer.render(records, view: :include_associations)
    else
      serializer.render(records, view: :include_associations, root: root)
    end
  end
end
