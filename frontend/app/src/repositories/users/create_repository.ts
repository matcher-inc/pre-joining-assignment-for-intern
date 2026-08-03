import { createPostFetch, type MyResponse } from "../create_fetch";

export type CreateUserParams = {
  user: {
    name: string;
  };
  userAuthentication: {
    identifier: string;
    password: string;
    passwordConfirmation: string;
  };
};

export const createUser = async (
  params: CreateUserParams,
): Promise<MyResponse> => {
  const fetchHandler = createPostFetch("/api/users", {
    body: {
      user: {
        name: params.user.name,
      },
      user_authentication: {
        identifier: params.userAuthentication.identifier,
        password: params.userAuthentication.password,
        password_confirmation: params.userAuthentication.passwordConfirmation,
      },
    },
  });

  return await fetchHandler();
};
