<template>
    <header>
        <img src="/img/logo.png" alt="Logo" />
        <h1>{{ uiLabels.about }}</h1>
    </header>
    <main></main>
    <FooterComponent></FooterComponent>
    <ResponsiveNav>
        <router-link to="/">
            {{ uiLabels.home || "HOME" }}
        </router-link>
        <router-link to="/about/">
            {{ uiLabels.about || "ABOUT" }}
        </router-link>
        <router-link to="/lobby/1">
            {{ uiLabels.play || "PLAY" }}
        </router-link>
        <router-link to="/create/">
            {{ uiLabels["createGame"] || "CREATE" }}
        </router-link>
        <button v-on:click="switchLanguage">
            {{ uiLabels.changeLanguage }}
        </button>
    </ResponsiveNav>
</template>

<script>
import ResponsiveNav from "@/components/ResponsiveNav.vue";
import FooterComponent from "@/components/FooterComponent.vue";
import io from "socket.io-client";
const socket = io(sessionStorage.getItem("dataServer"));

export default {
    name: "AboutView",
    components: {
        ResponsiveNav,
        FooterComponent,
    },
    data: function () {
        return {
            uiLabels: {},
            newPollId: "",
            lang: localStorage.getItem("lang") || "en",
            hideNav: true,
            showPollInput: false,
        };
    },
    created: function () {
        socket.on("uiLabels", (labels) => (this.uiLabels = labels));
        socket.emit("getUILabels", this.lang);
    },
    methods: {
        switchLanguage: function () {
            if (this.lang === "en") {
                this.lang = "sv";
            } else {
                this.lang = "en";
            }
            localStorage.setItem("lang", this.lang);
            socket.emit("getUILabels", this.lang);
        },
        toggleNav: function () {
            this.hideNav = !this.hideNav;
        },
    },
};
</script>

<style scoped>
header {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding-top: 4rem;
}

header img {
    width: 70%;
    height: auto;
    max-width: 30rem;
    max-height: 30rem;
    aspect-ratio: 1;
    padding-bottom: 1rem;
}

header h1,
h2 {
    font-size: 2rem;
    color: white;
    text-align: center;
}

main {
    color: white;
    padding-top: 5rem;
    padding-bottom: 10rem;
}

main a {
    color: white;
}
</style>
