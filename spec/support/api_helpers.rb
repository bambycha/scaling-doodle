module ApiHelpers
  def resp_body
    JSON.parse(response.body)
  end
end
