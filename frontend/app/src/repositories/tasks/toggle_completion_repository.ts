import { createPutFetch } from "../create_fetch";

type ToggleTaskCompletionPayload = {
  task: {
    id: number;
    is_completed: boolean;
  };
};

export const toggleTaskCompletion = async (
  taskId: number,
  isCompleted: boolean,
): Promise<ToggleTaskCompletionPayload> => {
  const action = isCompleted ? "complete" : "incomplete";
  const response = await createPutFetch<ToggleTaskCompletionPayload>(
    `/api/tasks/${taskId}/${action}`,
  )();

  return response.payload;
};
