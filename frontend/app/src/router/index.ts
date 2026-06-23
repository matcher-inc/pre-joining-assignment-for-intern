import {
  createRouter,
  createWebHistory,
  type RouteRecordRaw,
} from 'vue-router';

/* Import Pages /// */

import Root from '@/pages/Root.vue';

/* /// Import Pages */

const routes: RouteRecordRaw[] = [
  { path: '/', component: Root },
];

export const router = createRouter({
  history: createWebHistory(),
  routes,
});
