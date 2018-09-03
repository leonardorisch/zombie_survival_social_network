module JsonResponseHelper
  def error_response(message, status)
    render json: { message: message }, status: status
  end
end
