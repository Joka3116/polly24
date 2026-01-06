<template>
    <div class="top-right-header">
        <router-link to="/">Who wants to be<br>a millionaire?</router-link>
    </div>
</template>

<style scoped>
.top-right-header {
    position: absolute;
    right: 140px;
    top: 62px;
    z-index: 2;
    text-align: right;
    font-size: 1.2rem;
    font-family: "bebas-kai", sans-serif;
    text-transform: uppercase;
}
.top-right-header :deep(a) {
    color: gold !important;
    text-decoration: none;
}
.top-right-header :deep(a):hover {
    text-decoration: underline;
}
@media (max-width: 768px) {
    .top-right-header {
        position: absolute;
        right: 100px;
        top: 37px; 
        font-size: 1rem;
    }
}
</style>
