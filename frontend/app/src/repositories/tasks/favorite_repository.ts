import { createDeleteFetch, createPostFetch } from "../create_fetch";

type FavoriteTaskPayload = {
  task: {
    id: number;
    is_favorited: boolean;
  };
};

export const updateTaskFavorite = async (
  taskId: number,
  isFavorited: boolean,
): Promise<FavoriteTaskPayload> => {
  const url = `/api/tasks/${taskId}/favorite`;
  const fetchHandler = isFavorited
    ? createPostFetch<FavoriteTaskPayload>(url)
    : createDeleteFetch<FavoriteTaskPayload>(url);

  const response = await fetchHandler();
  return response.payload;
};
