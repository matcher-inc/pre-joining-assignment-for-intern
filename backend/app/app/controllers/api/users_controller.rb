module Api
  class UsersController < ::ApplicationController
    def create
      create_user_params = params
        .require(:user)
        .permit(:name)
      create_user_authentication_params = params
        .require(:user_authentication)
        .permit(:identifier, :password, :password_confirmation)

      user = ::Users.new(create_user_params)

      ActiveRecord::Base.transaction do
        user.save!
        user.create_user_authentication!(create_user_authentication_params)
      end

      render json: {}
    end
  end
end
