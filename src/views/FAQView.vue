<template>
    <header>
        <img src="/img/logo.png" alt="Logo" />
        <h1>{{ uiLabels.faq }}</h1>
    </header>
    <main>
        <section class="faq-section">
            <h2 class="faq-title">{{ uiLabels.faqTitle }}</h2>

            <div class="faq-item">
                <p class="faq-q">{{ uiLabels.faqQ1 }}</p>
                <p class="faq-a">{{ uiLabels.faqA1 }}</p>
            </div>

            <div class="faq-item">
                <p class="faq-q">{{ uiLabels.faqQ2 }}</p>
                <p class="faq-a">{{ uiLabels.faqA2 }}</p>
            </div>

            <div class="faq-item">
                <p class="faq-q">{{ uiLabels.faqQ3 }}</p>
                <p class="faq-a">{{ uiLabels.faqA3 }}</p>
            </div>

            <div class="faq-item">
                <p class="faq-q">{{ uiLabels.faqQ4 }}</p>
                <p class="faq-a">{{ uiLabels.faqA4 }}</p>
            </div>

            <div class="faq-item">
                <p class="faq-q">{{ uiLabels.faqQ5 }}</p>
                <p class="faq-a">{{ uiLabels.faqA5 }}</p>
            </div>
        </section>
    </main>

    <ResponsiveNav>
        <router-link to="/">
            {{ uiLabels.home || "HOME!" }}
        </router-link>
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
import LangSwitch from "@/components/LangSwitch.vue";

export default {
    name: "FAQView",
    components: {
        ResponsiveNav,
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
    text-shadow:
        0 0 10px rgba(255, 215, 0, 0.8),
        0 0 20px rgba(0, 0, 0, 0.9);
    margin-bottom: 2rem;
}

main p {
    font-size: 1.1rem;
    color: #e0e0e0;
    margin-bottom: 1.5rem;
}

.faq-section {
    max-width: 700px;
    margin: 3rem auto;
    padding: 0 10px;
}

.faq-title {
    font-size: 1.8rem;
    color: gold;
    margin-bottom: 2rem;
    text-transform: uppercase;
    letter-spacing: 2px;
}

@keyframes goldPulse {
    0% {
        border-left-color: #ffd700;
        box-shadow: -2px 0 5px rgba(255, 215, 0, 0.2);
    }
    50% {
        border-left-color: #fff200;
        box-shadow: -4px 0 15px rgba(255, 215, 0, 0.5);
    }
    100% {
        border-left-color: #ffd700;
        box-shadow: -2px 0 5px rgba(255, 215, 0, 0.2);
    }
}

.faq-item {
    margin-bottom: 2rem;
    text-align: left;
    padding: 1.2rem;
    background: rgba(0, 0, 0, 0.4);
    border-left: 3px solid var(--button-color); /* Guld */
    border-radius: 0 8px 8px 0;
    position: relative;
    overflow: hidden;
    animation: goldPulse 4s infinite ease-in-out;
}

.faq-item::before {
    content: "";
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: radial-gradient(
        circle at left,
        rgba(255, 215, 0, 0.05),
        transparent
    );
    pointer-events: none;
}

.faq-q {
    color: var(--button-color);
    font-family: "Courier New", monospace;
    font-weight: bold;
    font-size: 1.05rem;
    margin-bottom: 0.5rem;
}

.faq-a {
    color: #cbd5e0;
    line-height: 1.4;
    font-size: 0.95rem;
    opacity: 0.9;
}

header img {
    width: 60%;
    max-width: 250px;
    height: auto;
    margin-bottom: 1rem;
}
</style>
