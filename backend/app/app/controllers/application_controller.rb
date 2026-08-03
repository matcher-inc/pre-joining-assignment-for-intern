class ApplicationController < ActionController::API
  class Unauthorized < StandardError; end
  class BadRequest < StandardError; end

  rescue_from ::ActiveRecord::RecordInvalid, with: :render_422
  rescue_from ::ActiveRecord::RecordNotFound, with: :render_404
  rescue_from Unauthorized, with: :render_401
  rescue_from BadRequest, with: :render_400

  private

  def render_error(error=nil, status:)
    render(
      json: {
        error: error.try(:message),
      },
      status: status
    )
  end

  def render_400(error=nil)
    render_error(error, status: :bad_request)
  end

  def render_401(error=nil)
    render_error(error, status: :unauthorized)
  end

  def render_404(error=nil)
    render_error(error, status: :not_found)
  end

  def render_422(error=nil)
    render_error(error, status: :unprocessable_entity)
  end

  def current_user_identifier
    session[:identifier]
  end

  def set_current_user_identifier(identifier)
    session[:identifier] = identifier
  end

  def current_user
    return if current_user_identifier.blank?

    ::UserAuthentications.find_by(identifier: current_user_identifier)&.user
  end
end
