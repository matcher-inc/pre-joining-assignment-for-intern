<script lang="ts">
import { createUser } from "@/repositories/users/create_repository";
import { RoutesName } from "@/router/routes_name";
import { FetchError } from "@/repositories/create_fetch";

export default {
  data() {
    return {
      userName: "",
      identifier: "",
      password: "",
      passwordConfirmation: "",
    };
  },
  methods: {
    async onSubmit() {
      const createParams = {
        user: { name: this.userName },
        userAuthentication: {
          identifier: this.identifier,
          password: this.password,
          passwordConfirmation: this.passwordConfirmation,
        },
      };

      try {
        await createUser(createParams);
        this.$router.push({ name: RoutesName.SignInShow });
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
  <form action="/api/users" method="post" @submit.prevent="onSubmit">
    <div>
      <label for="form--user__name">ユーザー名</label>
      <input
        id="form--user__name"
        type="text"
        name="user[name]"
        autocomplete="off"
        v-model="userName"
      />
    </div>
    <div>
      <label for="form--user-authentication__identifier">ユーザーID</label>
      <input
        id="form--user-authentication__identifier"
        type="text"
        name="user_authentication[identifier]"
        autocomplete="username"
        pattern="[a-zA-Z0-9_]{8,32}"
        minlength="8"
        maxlength="32"
        v-model="identifier"
        required
      />
    </div>
    <div>
      <label for="form--user-authentication__password">パスワード</label>
      <input
        id="form--user-authentication__password"
        type="password"
        name="user_authentication[password]"
        autocomplete="new-password"
        minlength="8"
        maxlength="32"
        pattern="[0-9a-zA-Z_@\-]{8,32}"
        v-model="password"
        required
      />
    </div>
    <div>
      <label for="form--user-authentication__password_confirmation"
        >パスワード（確認用）</label
      >
      <input
        id="form--user-authentication__password_confirmation"
        type="password"
        name="user_authentication[password_confirmation]"
        autocomplete="new-password"
        minlength="8"
        maxlength="32"
        pattern="[0-9a-zA-Z_@\-]{8,32}"
        v-model="passwordConfirmation"
        required
      />
    </div>
    <input type="submit" value="新規作成" />
  </form>
</template>
