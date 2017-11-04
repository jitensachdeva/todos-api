module RequestSpecHelper
  def response_body_in_json
    JSON.parse(response.body)
  end
end