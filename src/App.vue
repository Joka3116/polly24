<script setup>
import { RouterView } from "vue-router";
import AppFooter from "@/components/AppFooter.vue";
</script>

<template>
    <div class="app-container">
        <RouterView />
    </div>
    <AppFooter />
</template>

<style>
.app-container {
    display: flex;
    flex-direction: column;
    min-height: 100vh !important;
    background: radial-gradient(circle, #0f2845, #02050a);
}

:deep(> div:first-child) {
    flex: 1;
}
</style>
