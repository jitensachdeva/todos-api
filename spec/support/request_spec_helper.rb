module RequestSpecHelper
  def response_in_json
    JSON.parse(response.body)
  end
end