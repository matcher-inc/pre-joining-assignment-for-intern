<script lang="ts">
import { FetchError } from "@/repositories/create_fetch";
import {
  newSession,
  createSession,
} from "@/repositories/sessions/create_repository";
import { RoutesName } from "@/router/routes_name";

export default {
  data() {
    return {
      identifier: "",
      password: "",
    };
  },
  mounted() {
    this.init();
  },
  methods: {
    async init() {
      const authStatus = await newSession();
      if (authStatus === "authenticated") {
        window.alert("すでにサインイン済みです");
        this.$router.push({ name: RoutesName.Root });
      }
    },
    async onSubmit() {
      try {
        await createSession({
          identifier: this.identifier,
          password: this.password,
        });
        const routeLocation = this.$router.resolve({ name: RoutesName.Root });
        window.location.href = routeLocation.href;
      } catch (error) {
        if (error instanceof FetchError) {
          window.alert(error.data.error);
        }
      }
    },
  },
};
</script>

<template>
  <form action="/api/sessions" method="post" @submit.prevent="onSubmit">
    <div>
      <label for="identifier">ユーザー識別子</label>
      <input
        id="identifier"
        type="text"
        autocomplete="username"
        v-model="identifier"
      />
    </div>
    <div>
      <label for="password">パスワード</label>
      <input
        id="password"
        type="password"
        autocomplete="current-password"
        v-model="password"
      />
    </div>
    <input type="submit" value="ログイン" />
  </form>
</template>
