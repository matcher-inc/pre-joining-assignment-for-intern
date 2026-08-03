import { createGetFetch } from "../create_fetch";

export type TaskListType = "my" | "others" | "favorites" | "following";
export type TaskCompletionFilter = "all" | "incomplete" | "complete";

export type Task = {
  id: number;
  body: string;
  is_completed: boolean;
  is_favorited: boolean;
  is_following: boolean;
  created_at: string;
  user: {
    id: number;
    name: string;
  };
};

type TaskListPayload = {
  tasks: Task[];
  has_next: boolean;
};

type FetchTasksParams = {
  type: TaskListType;
  completion: TaskCompletionFilter;
  page: number;
};

export const fetchTasks = async (
  params: FetchTasksParams,
): Promise<TaskListPayload> => {
  const response = await createGetFetch<TaskListPayload>("/api/tasks", {
    query: {
      type: params.type,
      completion: params.completion,
      page: params.page.toString(),
    },
  })();

  return response.payload;
};
