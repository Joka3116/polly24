<template>
    <footer>
        <p><strong>&copy;</strong> {{ currentYear }} 1MD031 - {{ uiLabels.group || "Group" }} 9<br>{{ uiLabels.uu || "Uppsala University" }}</p>
        <LangSwitch @switch-language="switchLanguage"></LangSwitch>
    </footer>
</template>

<script setup>
    import { ref, onMounted } from 'vue';
    import socket from "@/clientSocket.js";
    import LangSwitch from "@/components/LangSwitch.vue";

    const currentYear = new Date().getFullYear();
    const uiLabels = ref({});
    const lang = localStorage.getItem("lang") || "en";

    const switchLanguage = (newLang) => {
        socket.emit("getUILabels", newLang);
    };

    onMounted(() => {
        socket.on("uiLabels", (labels) => {
            uiLabels.value = labels;
        });
        socket.emit("getUILabels", lang);
    });
</script>

<style scoped>
footer {
    display: flex;
    flex-direction: row;
    align-items: center;
    justify-content: space-between;
    margin: 0;
    padding: 2.5rem;
    text-align: left;
    background-color: var(--background-alt-color);
}
@media (max-width: 768px) {
    footer {
        padding: 2.5rem 1.25rem 2.5rem 1.25rem; 
    }
}

footer p {
    color: var(--foreground-alt-color);
    margin: 0;
    padding: 0;
    line-height: 1.4;
}

footer .lang-switch-container {
    width: 6rem !important;
    height: 3rem !important;
}
footer .lang-switch-container :deep(.lang-switch-circle) {
    width: 50%;
    height: 100%;
}
footer .lang-switch-container :deep(.lang-switch-text-container) {
    font-size: 1.8rem !important;
}


</style>
