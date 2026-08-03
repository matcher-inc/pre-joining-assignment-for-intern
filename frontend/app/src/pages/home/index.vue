<script lang="ts">
import { FetchError } from "@/repositories/create_fetch";
import { createTask } from "@/repositories/tasks/create_repository";
import { updateTaskFavorite } from "@/repositories/tasks/favorite_repository";
import {
  fetchTasks,
  type Task,
  type TaskCompletionFilter,
  type TaskListType,
} from "@/repositories/tasks/index_repository";
import { toggleTaskCompletion } from "@/repositories/tasks/toggle_completion_repository";
import { updateUserFollow } from "@/repositories/users/follow_repository";

export default {
  data() {
    return {
      body: "",
      tasks: [] as Task[],
      selectedTaskType: "my" as TaskListType,
      selectedCompletion: "all" as TaskCompletionFilter,
      currentPage: 0,
      hasNext: false,
      isCreatingTask: false,
      isLoadingTasks: false,
      taskRequestId: 0,
      updatingTaskIds: [] as number[],
      updatingFavoriteTaskIds: [] as number[],
      updatingFollowUserIds: [] as number[],
    };
  },
  mounted() {
    this.showTasks("my");
  },
  methods: {
    async createTask() {
      const body = this.body.trim();

      if (!body) {
        window.alert("タスク内容を入力してください");
        return;
      }

      this.isCreatingTask = true;

      try {
        await createTask({ body });
        this.body = "";
        await this.showTasks("my");
      } catch (error) {
        if (error instanceof FetchError) {
          window.alert(String(error.data.error));
        } else {
          window.alert("タスクの作成に失敗しました");
        }
      } finally {
        this.isCreatingTask = false;
      }
    },
    async showTasks(taskType: TaskListType) {
      this.selectedTaskType = taskType;
      this.currentPage = 0;
      this.tasks = [];
      this.hasNext = false;

      await this.loadTasks(false);
    },
    async loadMoreTasks() {
      if (this.isLoadingTasks || !this.hasNext) return;

      await this.loadTasks(true);
    },
    async loadTasks(append: boolean) {
      const requestId = ++this.taskRequestId;
      const requestedType = this.selectedTaskType;
      const requestedPage = append ? this.currentPage + 1 : 1;
      this.isLoadingTasks = true;

      try {
        const payload = await fetchTasks({
          type: requestedType,
          completion: this.selectedCompletion,
          page: requestedPage,
        });

        if (requestId !== this.taskRequestId) return;

        this.tasks = append ? [...this.tasks, ...payload.tasks] : payload.tasks;
        this.currentPage = requestedPage;
        this.hasNext = payload.has_next;
      } catch (error) {
        if (requestId !== this.taskRequestId) return;

        if (error instanceof FetchError) {
          window.alert(String(error.data.error));
        } else {
          window.alert("タスク一覧の取得に失敗しました");
        }
      } finally {
        if (requestId === this.taskRequestId) {
          this.isLoadingTasks = false;
        }
      }
    },
    async reloadTasks() {
      await this.showTasks(this.selectedTaskType);
    },
    async updateTaskCompletion(task: Task) {
      if (this.updatingTaskIds.includes(task.id)) return;

      const nextIsCompleted = !task.is_completed;
      task.is_completed = nextIsCompleted;
      this.updatingTaskIds.push(task.id);

      try {
        const payload = await toggleTaskCompletion(
          task.id,
          nextIsCompleted,
        );
        task.is_completed = payload.task.is_completed;
      } catch (error) {
        task.is_completed = !nextIsCompleted;

        if (error instanceof FetchError) {
          window.alert(String(error.data.error));
        } else {
          window.alert("タスクの完了状態の更新に失敗しました");
        }
      } finally {
        this.updatingTaskIds = this.updatingTaskIds.filter(
          (taskId) => taskId !== task.id,
        );
      }
    },
    isUpdatingTask(taskId: number) {
      return this.updatingTaskIds.includes(taskId);
    },
    async toggleTaskFavorite(task: Task) {
      if (this.updatingFavoriteTaskIds.includes(task.id)) return;

      const nextIsFavorited = !task.is_favorited;
      task.is_favorited = nextIsFavorited;
      this.updatingFavoriteTaskIds.push(task.id);

      try {
        const payload = await updateTaskFavorite(task.id, nextIsFavorited);
        task.is_favorited = payload.task.is_favorited;

        if (!task.is_favorited && this.selectedTaskType === "favorites") {
          await this.showTasks("favorites");
        }
      } catch (error) {
        task.is_favorited = !nextIsFavorited;

        if (error instanceof FetchError) {
          window.alert(String(error.data.error));
        } else {
          window.alert("お気に入り状態の更新に失敗しました");
        }
      } finally {
        this.updatingFavoriteTaskIds =
          this.updatingFavoriteTaskIds.filter(
            (taskId) => taskId !== task.id,
          );
      }
    },
    isUpdatingFavoriteTask(taskId: number) {
      return this.updatingFavoriteTaskIds.includes(taskId);
    },
    async toggleUserFollow(task: Task) {
      const userId = task.user.id;
      if (this.updatingFollowUserIds.includes(userId)) return;

      const nextIsFollowing = !task.is_following;
      const sameUserTasks = this.tasks.filter(
        (listedTask) => listedTask.user.id === userId,
      );
      sameUserTasks.forEach((listedTask) => {
        listedTask.is_following = nextIsFollowing;
      });
      this.updatingFollowUserIds.push(userId);

      try {
        const payload = await updateUserFollow(userId, nextIsFollowing);
        sameUserTasks.forEach((listedTask) => {
          listedTask.is_following = payload.user.is_following;
        });

        if (!payload.user.is_following && this.selectedTaskType === "following") {
          await this.showTasks("following");
        }
      } catch (error) {
        sameUserTasks.forEach((listedTask) => {
          listedTask.is_following = !nextIsFollowing;
        });

        if (error instanceof FetchError) {
          window.alert(String(error.data.error));
        } else {
          window.alert("フォロー状態の更新に失敗しました");
        }
      } finally {
        this.updatingFollowUserIds = this.updatingFollowUserIds.filter(
          (updatingUserId) => updatingUserId !== userId,
        );
      }
    },
    isUpdatingFollowUser(userId: number) {
      return this.updatingFollowUserIds.includes(userId);
    },
    formatCreatedAt(createdAt: string) {
      const date = new Date(createdAt);
      if (Number.isNaN(date.getTime())) return createdAt;

      return new Intl.DateTimeFormat("ja-JP", {
        dateStyle: "medium",
        timeStyle: "short",
      }).format(date);
    },
  },
};
</script>

<template>
  <main class="home">
  <form class="task-form" @submit.prevent="createTask">
    <div>
      <label for="task_body">タスク内容</label>
      <input id="task_body" type="text" v-model="body" />
    </div>
    <input
      type="submit"
      value="タスクを作成"
      :disabled="isCreatingTask"
    />
  </form>

  <section class="task-list">
    <div class="task-list__filter">
      <label for="completion_filter">完了状態</label>
      <select
        id="completion_filter"
        v-model="selectedCompletion"
        :disabled="isLoadingTasks"
        @change="reloadTasks"
      >
        <option value="all">すべて</option>
        <option value="incomplete">未完了</option>
        <option value="complete">完了</option>
      </select>
    </div>

    <nav class="task-list__tabs" aria-label="タスク一覧の種類">
      <button
        type="button"
        :aria-pressed="selectedTaskType === 'my'"
        :disabled="isLoadingTasks"
        @click="showTasks('my')"
      >
        My タスク
      </button>
      <button
        type="button"
        :aria-pressed="selectedTaskType === 'others'"
        :disabled="isLoadingTasks"
        @click="showTasks('others')"
      >
        みんなのタスク
      </button>
      <button
        type="button"
        :aria-pressed="selectedTaskType === 'favorites'"
        :disabled="isLoadingTasks"
        @click="showTasks('favorites')"
      >
        お気に入りタスク
      </button>
      <button
        type="button"
        :aria-pressed="selectedTaskType === 'following'"
        :disabled="isLoadingTasks"
        @click="showTasks('following')"
      >
        フォロー中のタスク
      </button>
    </nav>

    <p v-if="isLoadingTasks && tasks.length === 0">読み込み中...</p>
    <p v-else-if="tasks.length === 0">表示できるタスクはありません</p>
    <ul v-else class="task-list__items">
      <li v-for="task in tasks" :key="task.id">
        <div class="task-list__meta">
          <strong>{{ task.user.name }}</strong>
          <time :datetime="task.created_at">
            {{ formatCreatedAt(task.created_at) }}
          </time>
        </div>
        <p>{{ task.body }}</p>
        <label v-if="selectedTaskType === 'my'">
          <input
            type="checkbox"
            :checked="task.is_completed"
            :disabled="isUpdatingTask(task.id)"
            @change="updateTaskCompletion(task)"
          />
          完了
        </label>
        <span v-else>
          {{ task.is_completed ? "完了" : "未完了" }}
        </span>
        <button
          v-if="selectedTaskType !== 'my'"
          type="button"
          :disabled="isUpdatingFavoriteTask(task.id)"
          @click="toggleTaskFavorite(task)"
        >
          {{ task.is_favorited ? "お気に入り解除" : "お気に入り" }}
        </button>
        <button
          v-if="selectedTaskType !== 'my'"
          type="button"
          :disabled="isUpdatingFollowUser(task.user.id)"
          @click="toggleUserFollow(task)"
        >
          {{ task.is_following ? "アンフォロー" : "フォロー" }}
        </button>
      </li>
    </ul>

    <button
      v-if="hasNext"
      type="button"
      :disabled="isLoadingTasks"
      @click="loadMoreTasks"
    >
      {{ isLoadingTasks ? "読み込み中..." : "さらに読み込む" }}
    </button>
  </section>
  </main>
</template>

<style scoped>
.home {
  max-width: 720px;
  margin: 0 auto;
  padding: 24px 16px;
}

.task-form {
  padding-bottom: 24px;
  border-bottom: 1px solid #d8d8d8;
}

.task-form div {
  display: flex;
  gap: 8px;
  align-items: center;
  margin-bottom: 12px;
}

.task-form input[type="text"] {
  flex: 1;
}

.task-list {
  padding-top: 24px;
}

.task-list__filter {
  display: flex;
  gap: 8px;
  align-items: center;
  margin-bottom: 16px;
}

.task-list__tabs {
  display: flex;
  gap: 8px;
  margin-bottom: 16px;
}

.task-list__tabs button[aria-pressed="true"] {
  font-weight: bold;
  text-decoration: underline;
}

.task-list__items {
  padding: 0;
  margin: 0 0 16px;
  list-style: none;
}

.task-list__items li {
  padding: 16px 0;
  border-bottom: 1px solid #d8d8d8;
}

.task-list__items p {
  margin-bottom: 0;
  white-space: pre-wrap;
  overflow-wrap: anywhere;
}

.task-list__meta {
  display: flex;
  gap: 12px;
  justify-content: space-between;
}

.task-list__meta time {
  color: #666;
  font-size: 0.875rem;
}
</style>
