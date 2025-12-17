<template>
    <footer>
        <p>&copy; {{ currentYear }} Polly24</p>
    </footer>
</template>

<script setup>
    const currentYear = new Date().getFullYear();
</script>

<style scoped>
footer {
    margin: 0;
    padding: 0;
    text-align: left;
    background-color: var(--background-alt-color);
}

footer p {
    color: var(--foreground-alt-color);
    margin: 0;
    padding: 3rem;
}
</style>
