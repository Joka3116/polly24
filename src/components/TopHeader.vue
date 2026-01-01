<template>
    <header>
        <img src="/img/logo.png" alt="Logo" />
    </header>
</template>

<script setup>
// const currentYear = new Date().getFullYear();
</script>

<style scoped>
header {
    padding-top: calc(2.5rem - 5px);
    padding-left: calc(2.5rem - 2px);
    display: flex;
    flex-direction: row;
    align-items: center;
}

header img {
    width: 12rem;
    height: auto;
    width: 5.1rem;
    height: 5.1rem;
    aspect-ratio: 1;
}

header p {
    font-size: 1.1rem;
    color: var(--headline-color);
    font-family: "bebas-kai", sans-serif;
}
</style>
