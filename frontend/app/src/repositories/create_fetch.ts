import {
  BASE_SERVER_URL,
  type CONTENT_TYPES,
  type HTTP_METHODS,
  type ACCEPT_TYPES,
} from "./constants";

export type MyResponse<Payload = Record<string, unknown>> = {
  payload: Payload;
  status: number;
};

type Fetch<Payload = Record<string, unknown>> = () => Promise<
  MyResponse<Payload>
>;

export class FetchError extends Error {
  public readonly data: Record<string, unknown>;

  constructor(data: Record<string, unknown>, message?: string) {
    super(message ?? "Fetch error.");
    this.data = data;
  }
}

const _createBaseFetch = <Payload = Record<string, unknown>>(
  url: string,
  method: HTTP_METHODS,
  options?: {
    body?: Record<string, unknown>;
    contentType?: CONTENT_TYPES;
    accept?: ACCEPT_TYPES;
  },
): Fetch<Payload> => {
  const body = options?.body ? JSON.stringify(options.body) : undefined;
  const headers: Map<string, string> = new Map<string, string>([
    ["Content-Type", "application/json"],
    ["Accept", "application/json"],
  ]);

  if (options?.contentType) {
    headers.set("Content-Type", options.contentType);
  }

  if (options?.accept) {
    headers.set("Accept", options.accept);
  }

  const requestInit: RequestInit = {
    method,
    body,
    credentials: "include",
    mode: "cors",
    headers: Object.fromEntries(headers),
  };

  return (): Promise<MyResponse<Payload>> =>
    fetch(url, requestInit).then(
      async (response: Response): Promise<MyResponse<Payload>> => {
        const payload = (await response.json()) as Payload;
        if (!response.ok) {
          throw new FetchError(
            payload as Record<string, unknown>,
            "this is error.",
          );
        }

        return {
          payload,
          status: response.status,
        };
      },
    );
};

export const createGetFetch = <Payload = Record<string, unknown>>(
  url: string,
  options?: {
    query?: Record<string, string>;
  },
): Fetch<Payload> => {
  const query = options?.query
    ? new URLSearchParams(options.query).toString()
    : "";
  const requestUrl = `${BASE_SERVER_URL}${url}${query ? `?${query}` : ""}`;

  return _createBaseFetch<Payload>(requestUrl, "get");
};

export const createPostFetch = <Payload = Record<string, unknown>>(
  url: string,
  options?: {
    body?: Record<string, unknown>;
  },
): Fetch<Payload> => {
  return _createBaseFetch<Payload>(`${BASE_SERVER_URL}${url}`, "post", {
    body: options?.body,
  });
};

export const createPutFetch = <Payload = Record<string, unknown>>(
  url: string,
  options?: {
    body?: Record<string, unknown>;
  },
): Fetch<Payload> => {
  return _createBaseFetch<Payload>(`${BASE_SERVER_URL}${url}`, "put", {
    body: options?.body,
  });
};

export const createDeleteFetch = <Payload = Record<string, unknown>>(
  url: string,
): Fetch<Payload> => {
  return _createBaseFetch<Payload>(`${BASE_SERVER_URL}${url}`, "delete");
};
