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
    margin: 0;
    padding: 0;
    text-align: left;
}

footer p {
    color: white;
    margin: 0;
    padding: 3rem;
}
</style>
