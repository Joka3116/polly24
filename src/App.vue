<script setup>
import { RouterView } from "vue-router";
import FooterComponent from "@/components/FooterComponent.vue";
</script>

<template>
    <div class="app-container">
        <RouterView />
    </div>
    <FooterComponent />
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
