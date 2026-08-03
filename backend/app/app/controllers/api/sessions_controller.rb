module Api
  class SessionsController < ::ApplicationController
    def new
      status = if current_user_identifier.present?
        'authenticated'
      else
        'unauthenticated'
      end

      render json: { status: status }
    end

    def create
      raise BadRequest, 'すでにサインイン済みです' if current_user_identifier.present?

      user_authentication = fetch_user_authentication(params)

      unless user_authentication.present?
        raise Unauthorized, "ユーザー識別子またはパスワードが誤っています"
      end

      set_current_user_identifier(user_authentication.identifier)

      render(json: {}, status: :ok)
    end

    private

    def fetch_user_authentication(params)
      data = params.require(:user_authentication).permit(:identifier, :password)
      ::UserAuthentications.authenticate_by(
        identifier: data[:identifier],
        password: data[:password],
      )
    end
  end
end
