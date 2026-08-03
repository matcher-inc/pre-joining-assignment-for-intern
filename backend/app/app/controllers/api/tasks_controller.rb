module Api
  class TasksController < ::ApplicationController
    TASKS_PER_PAGE = 15
    TASK_TYPES = %w[my others favorites following].freeze
    COMPLETION_FILTERS = %w[all incomplete complete].freeze

    def index
      user = current_user
      raise Unauthorized, "サインインが必要です" unless user

      task_type = params.fetch(:type, "my")
      unless TASK_TYPES.include?(task_type)
        raise BadRequest, "type は my、others、favorites、following のいずれかを指定してください"
      end

      completion = params.fetch(:completion, "all")
      unless COMPLETION_FILTERS.include?(completion)
        raise BadRequest, "completion は all、incomplete、complete のいずれかを指定してください"
      end

      page = fetch_page
      tasks = fetch_tasks(user, task_type, completion, page)
      has_next = tasks.length > TASKS_PER_PAGE
      displayed_tasks = tasks.first(TASKS_PER_PAGE)
      favorited_task_ids = fetch_favorited_task_ids(user, task_type, displayed_tasks)
      followed_user_ids = fetch_followed_user_ids(user, task_type, displayed_tasks)

      render json: {
        tasks: displayed_tasks.map do |task|
          task_json(
            task,
            favorited_task_ids.include?(task.id),
            followed_user_ids.include?(task.user_id)
          )
        end,
        has_next: has_next
      }, status: :ok
    end

    def create
      user = current_user
      raise Unauthorized, "サインインが必要です" unless user

      user.tasks.create!(task_params)

      render json: {}, status: :created
    end

    def complete
      update_completion(true)
    end

    def incomplete
      update_completion(false)
    end

    private

    def fetch_page
      page = params.fetch(:page, "1").to_s
      raise BadRequest, "page は1以上の整数を指定してください" unless page.match?(/\A[1-9]\d*\z/)

      page.to_i
    end

    def fetch_tasks(user, task_type, completion, page)
      tasks =
        case task_type
        when "my"
          user.tasks
        when "others"
          ::Tasks.where.not(user_id: user.id)
        when "favorites"
          user.favorited_tasks
        when "following"
          ::Tasks.where(user_id: user.following_users.select(:id))
        end
      tasks = tasks.where(is_completed: false) if completion == "incomplete"
      tasks = tasks.where(is_completed: true) if completion == "complete"

      tasks
        .includes(:user)
        .order(created_at: :desc, id: :desc)
        .offset((page - 1) * TASKS_PER_PAGE)
        .limit(TASKS_PER_PAGE + 1)
        .to_a
    end

    def fetch_favorited_task_ids(user, task_type, tasks)
      task_ids = tasks.map(&:id)
      return [] if task_type == "my" || task_ids.empty?
      return task_ids if task_type == "favorites"

      user.favorite_tasks.where(task_id: task_ids).pluck(:task_id)
    end

    def fetch_followed_user_ids(user, task_type, tasks)
      user_ids = tasks.map(&:user_id).uniq
      return [] if task_type == "my" || user_ids.empty?
      return user_ids if task_type == "following"

      user.active_follows.where(target_user_id: user_ids).pluck(:target_user_id)
    end

    def update_completion(is_completed)
      user = current_user
      raise Unauthorized, "サインインが必要です" unless user

      task = user.tasks.find(params[:task_id])
      task.update!(is_completed: is_completed)

      render json: {
        task: {
          id: task.id,
          is_completed: task.is_completed
        }
      }, status: :ok
    end

    def task_json(task, is_favorited, is_following)
      {
        id: task.id,
        body: task.body,
        is_completed: task.is_completed,
        is_favorited: is_favorited,
        is_following: is_following,
        created_at: task.created_at,
        user: {
          id: task.user.id,
          name: task.user.name
        }
      }
    end

    def task_params
      params.require(:task).permit(:body)
    end
  end
end
