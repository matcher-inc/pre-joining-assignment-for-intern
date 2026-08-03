import {
  createGetFetch,
  createPostFetch,
  type MyResponse,
} from "../create_fetch";

export type CreateSessionParams = {
  identifier: string;
  password: string;
};

export const newSession = async (): Promise<
  "authenticated" | "unauthenticated"
> => {
  const res = await createGetFetch("/api/sessions/new")();
  const status = res.payload.status;
  if (status === "authenticated") return "authenticated";
  else if (status === "unauthenticated") return "unauthenticated";
  else throw new Error("Unexpected data format");
};

export const createSession = async (
  params: CreateSessionParams,
): Promise<MyResponse> => {
  const fetchHandler = createPostFetch("/api/sessions", {
    body: {
      user_authentication: {
        identifier: params.identifier,
        password: params.password,
      },
    },
  });

  return await fetchHandler();
};
