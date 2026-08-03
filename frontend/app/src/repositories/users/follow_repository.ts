import { createDeleteFetch, createPutFetch } from "../create_fetch";

type FollowUserPayload = {
  user: {
    id: number;
    is_following: boolean;
  };
};

export const updateUserFollow = async (
  userId: number,
  isFollowing: boolean,
): Promise<FollowUserPayload> => {
  const url = `/api/users/follow/${userId}`;
  const fetchHandler = isFollowing
    ? createPutFetch<FollowUserPayload>(url)
    : createDeleteFetch<FollowUserPayload>(url);

  const response = await fetchHandler();
  return response.payload;
};
