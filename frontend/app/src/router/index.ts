import {
  createRouter,
  createWebHistory,
  type RouteRecordRaw,
} from "vue-router";
import { RoutesName } from "./routes_name";

/* Import Pages /// */

import Root from "@/pages/Root.vue";
import SignUpShow from "@/pages/sign_up/index.vue";
import SignInShow from "@/pages/sign_in/index.vue";
import Home from "@/pages/home/index.vue";

/* /// Import Pages */

const routes: RouteRecordRaw[] = [
  { path: "/sign_up", component: SignUpShow, name: RoutesName.SignUpShow },
  { path: "/sign_in", component: SignInShow, name: RoutesName.SignInShow },
  {
    path: "/",
    component: Root,
    name: RoutesName.Root,
    children: [{ path: "", component: Home, name: RoutesName.Home }],
  },
];

export const router = createRouter({
  history: createWebHistory(),
  routes,
});
