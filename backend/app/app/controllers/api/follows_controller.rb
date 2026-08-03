module Api
  class FollowsController < ::ApplicationController
    def create
      user = current_user
      raise Unauthorized, "サインインが必要です" unless user

      target_user = ::Users.find(params[:target_user_id])
      follow = user.active_follows.create!(target_user: target_user)

      render_follow(follow.target_user_id, true)
    end

    def destroy
      user = current_user
      raise Unauthorized, "サインインが必要です" unless user

      follow = user.active_follows.find_by!(target_user_id: params[:target_user_id])
      target_user_id = follow.target_user_id
      follow.destroy!

      render_follow(target_user_id, false)
    end

    private

    def render_follow(target_user_id, is_following)
      render json: {
        user: {
          id: target_user_id,
          is_following: is_following
        }
      }, status: :ok
    end
  end
end
