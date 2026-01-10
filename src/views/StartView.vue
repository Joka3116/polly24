<template>
    <header>
        <img src="/img/logo.png" alt="Logo" />
        <h1>{{ uiLabels["sales-pitch"] }}</h1>
        <h2>{{ uiLabels.subHeading }}</h2>
    </header>
    
    <main>
        <div class="button-group">
            <button
                v-if="!showGameInput"
                class="btn-main"
                @click="showGameInput = true"
            >
                {{ uiLabels.play || "PLAY!" }}
            </button>

            <GameInput
                v-else
                :uiLabels="uiLabels"
                @cancel="showGameInput = false"
            />

            <button
                v-if="!showGameInput"
                class="btn-main"
                @click="$router.push('/create')"
            >
                {{ uiLabels["createGame"] || "CREATE!" }}
            </button>
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
import ResponsiveNav from "@/components/ResponsiveNav.vue";
import LangSwitch from "@/components/LangSwitch.vue";
import GameInput from "@/components/GameInput.vue";
import socket from "@/clientSocket.js";

export default {
    name: "StartView",
    components: {
        ResponsiveNav,
        LangSwitch,
        GameInput,
    },
    data: function () {
        return {
            uiLabels: {},
            lang: localStorage.getItem("lang") || "en",
            showGameInput: false,
        };
    },
    created: function () {
        socket.on("uiLabels", (labels) => (this.uiLabels = labels));
        socket.emit("getUILabels", this.lang);
    },
    methods: {
        switchLanguage: function (lang) {
            if (lang) {
               this.lang = lang; 
            } else {
                // Fallback / toggle if called without argument (though LangSwitch provides it now)
                this.lang = this.lang === "en" ? "sv" : "en";
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
    padding-top: 8dvh;
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
    text-shadow:
        0 0 10px rgba(255, 215, 0, 0.8),
        0 0 20px rgba(0, 0, 0, 0.9);
    text-align: center;
    text-wrap: balance !important;
}

main {
    color: white;
    padding-top: 10dvh;
    padding-bottom: 5rem;
}

.button-group {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 1.5rem;
    margin-top: 1rem;
}

</style>
