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
    padding-left: 1rem;
    padding-right: 1rem;
}

@media (min-width: 1024px) {
    .app-container {
        padding-left: 1.25rem;
        padding-right: 1.25rem;
    }
}

:deep(> div:first-child) {
    flex: 1;
}
</style>
