<template>
    <footer>
        <p>&copy; {{ currentYear }} Polly24</p>
    </footer>
</template>

<script setup>
// No need for imports if just getting the date
const currentYear = new Date().getFullYear();
</script>

<style scoped>
footer {
    padding: 3rem;
    background-color: var(--background-alt-color);
    text-align: left;
}

footer p {
    color: var(--foreground-alt-color);
    margin: 0; /* Good practice to remove default browser margins in footers */
}
</style>
