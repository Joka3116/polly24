<script setup>
import { RouterView } from 'vue-router'
import FooterComponent from '@/components/FooterComponent.vue'
</script>

<template>
  <div class="app-container">
    <RouterView />
    <FooterComponent />
  </div>
</template>

<style>
.app-container {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}

:deep(> div:first-child) {
  flex: 1;
}
</style>
