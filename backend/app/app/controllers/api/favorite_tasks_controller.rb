module Api
  class FavoriteTasksController < ::ApplicationController
    def create
      user = current_user
      raise Unauthorized, "サインインが必要です" unless user

      task = ::Tasks.find(params[:task_id])
      favorite_task = user.favorite_tasks.create!(task: task)

      render_favorite_task(favorite_task.task_id, true, :created)
    end

    def destroy
      user = current_user
      raise Unauthorized, "サインインが必要です" unless user

      favorite_task = user.favorite_tasks.find_by!(task_id: params[:task_id])
      task_id = favorite_task.task_id
      favorite_task.destroy!

      render_favorite_task(task_id, false, :ok)
    end

    private

    def render_favorite_task(task_id, is_favorited, status)
      render json: {
        task: {
          id: task_id,
          is_favorited: is_favorited
        }
      }, status: status
    end
  end
end
