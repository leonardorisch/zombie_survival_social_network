module JsonResponseHelper
  def json_response(message, status)
    render json: message, status: status
  end
end
