<template>
    <header>
        <img src="/img/logo.png" alt="Logo" />
        <h1>{{ uiLabels["sales-pitch"] }}</h1>
        <h2>{{ uiLabels.subHeading }}</h2>
    </header>
    
    <main>
        <div class="button-group">
            <Transition name="slide-fade" mode="out-in">
                <div v-if="!showGameInput" class="menu-buttons">
                    <button
                        class="btn-main"
                        @click="showGameInput = true"
                    >
                        {{ uiLabels.play || "PLAY!" }}
                    </button>
                    <button
                        class="btn-main"
                        @click="$router.push('/create')"
                    >
                        {{ uiLabels["createGame"] || "CREATE!" }}
                    </button>
                </div>

                <GameInput
                    v-else
                    :uiLabels="uiLabels"
                    @cancel="showGameInput = false"
                />
            </Transition>
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
import socket from "@/socket.js";

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
    width: 100%;
    display: flex;
    flex-direction: column;
    align-items: center;
    margin-top: 1rem;
    min-height: 12rem; /* Reserve space to prevent jumpiness, adjust as needed */
}

.menu-buttons {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 1.5rem;
    width: 100%;
}

/* Transitions */
.slide-fade-enter-active {
    transition: all 0.15s ease-out;
}

.slide-fade-leave-active {
    transition: all 0.15s cubic-bezier(1, 0.5, 0.8, 1);
}

.slide-fade-enter-from,
.slide-fade-leave-to {
    transform: translateY(20px);
    opacity: 0;
}

</style>
