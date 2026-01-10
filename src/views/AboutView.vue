<template>
    <TopRightHeader />
    <header>
        <h1>{{ uiLabels.about }}</h1>
    </header>  
    <main>
        <div class="about-content">
            <h2>{{ uiLabels.aboutTitle }}</h2>
            <p>{{ uiLabels.aboutText1 }}</p>
            <p>{{ uiLabels.aboutText2 }}</p>
            <p>{{ uiLabels.aboutText3 }}</p>
        </div>
    </main>
    <ResponsiveNav>
        <router-link to="/about/">
            {{ uiLabels.about || "ABOUT!" }}
        </router-link>
        <router-link to="/faq/">
            {{ uiLabels.faq || "FAQ!" }}
        </router-link>
        <router-link to="/lobby/">
            {{ uiLabels.play || "PLAY!" }}
        </router-link>
        <router-link to="/create/">
            {{ uiLabels["createGame"] || "CREATE!" }}
        </router-link>
        <LangSwitch @switch-language="switchLanguage" />  
    </ResponsiveNav>
</template>
<script>
import socket from "@/clientSocket.js";
import ResponsiveNav from "@/components/ResponsiveNav.vue";
import TopRightHeader from "@/components/TopRightHeader.vue";
import LangSwitch from "@/components/LangSwitch.vue";

export default {
    name: "AboutView",
    components: {
        ResponsiveNav,
        TopRightHeader,
        LangSwitch,
    },
    data: function () {
        return {
            uiLabels: {},
            lang: localStorage.getItem("lang") || "en",
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
    },
};
</script>

<style scoped>
header {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding-top: clamp(8rem, 8dvh, 10rem);
    margin-bottom: 3rem;
}

@media (min-width: 1024px) {
    header {
        padding-top: clamp(10rem, 8dvh, 12rem);
    }
}
header h1,
h2 {
    color: var(--headline-color);
    text-align: center;
    text-shadow:
        0 0 10px rgba(255, 215, 0, 0.8),
        0 0 20px rgba(0, 0, 0, 0.9);
}
h2 {
    margin-bottom: 1.5rem;
    text-wrap: balance;
}
main p {
    font-size: 1.1rem;
    color: #e0e0e0;
    margin-bottom: 1.5rem;
    line-height: 1.8;
}
.about-content {
    max-width: 1024px;
    margin: 0 auto 3rem auto;
    padding: 2rem;
    background-color: rgba(10, 48, 76, 0.7);
    border-radius: 16px;
    border: 1px solid gold;
    box-shadow: 0 0 20px rgba(255, 215, 0, 0.1);
}

</style>
