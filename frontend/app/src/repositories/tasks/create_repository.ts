import { createPostFetch, type MyResponse } from "../create_fetch";

export type CreateTaskParams = {
  body: string;
};

export const createTask = async (
  params: CreateTaskParams,
): Promise<MyResponse> => {
  return await createPostFetch("/api/tasks", {
    body: {
      task: {
        body: params.body,
      },
    },
  })();
};
