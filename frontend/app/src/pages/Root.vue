<script lang="ts">
import RootComponent from "@/components/Root.component.vue";
import { newSession } from "@/repositories/sessions/create_repository";
import { RoutesName } from "@/router/routes_name";

export default {
  components: {
    RootComponent,
  },
  data() {
    return {
      hasInitialized: false,
    };
  },
  mounted() {
    console.log("mounted root.vue");
    this.init();
  },
  unmounted() {
    console.log("unmounted root.vue");
  },
  methods: {
    async init() {
      const authStatus = await newSession();
      if (authStatus === "unauthenticated") {
        this.$router.push({ name: RoutesName.SignInShow });
      } else {
        this.hasInitialized = true;
      }
    },
  },
};
</script>

<template>
  <router-view v-if="hasInitialized" />
</template>
