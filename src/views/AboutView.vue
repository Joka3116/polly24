<template>
    <div class="content-container">
    <header>
        <img src="/img/logo.png" alt="Logo" />
        <h1>{{ uiLabels.aboutTitle }}</h1>
    </header>
    <main>
        <div class="about-content">
            <p>{{ uiLabels.aboutText1 }}</p>
            <p>{{ uiLabels.aboutText2 }}</p>
            <p>{{ uiLabels.aboutText3 }}</p>
        </div>
    </main>
    </div>
    <FooterComponent></FooterComponent>
    <ResponsiveNav>
        <router-link to="/">
            {{ uiLabels.home || "HOME!" }}
        </router-link>
        <router-link to="/about/">
            {{ uiLabels.about || "ABOUT!" }}
        </router-link>
        <router-link to="/lobby/1">
            {{ uiLabels.play || "PLAY!" }}
        </router-link>
        <router-link to="/create/">
            {{ uiLabels["createGame"] || "CREATE!" }}
        </router-link>
        <button v-on:click="switchLanguage">
            {{ uiLabels.changeLanguage }}
        </button>
    </ResponsiveNav>
</template>

<script>
import socket from "@/socket.js";
import ResponsiveNav from "@/components/ResponsiveNav.vue";
import FooterComponent from "@/components/FooterComponent.vue";

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
    width: 60%;
    height: auto;
    max-width: 30rem;
    max-height: 30rem;
    aspect-ratio: 1;
    padding-bottom: 2rem;
}


header h1,
h2 {
    color: var(--headline-color);
    text-align: center;
    text-shadow: 0 0 10px rgba(255, 215, 0, 0.8), 0 0 20px rgba(0, 0, 0, 0.9);
    margin-bottom: 2rem;
}

.about-content {
    max-width: 700px;
    margin: 0 auto; 
    padding: 30px; 
    background-color: rgba(10, 48, 76, 0.7); 
    border-radius: 15px;
    border: 1px solid gold; 
    box-shadow: 0 0 20px rgba(255, 215, 0, 0.1);
    line-height: 1.8; 
}

main p {
    font-size: 1.1rem;
    color: #e0e0e0; 
    margin-bottom: 1.5rem;
}
</style>
