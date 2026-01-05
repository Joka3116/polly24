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

            <div v-else class="game-input-area">
                <input
                    type="text"
                    class="input-main"
                    v-model="newGameId"
                    :placeholder="uiLabels['gameID'] || 'Game ID'"
                    v-on:keyup.enter="joinGame"
                />

                <button class="btn-main" @click="joinGame">
                    {{ uiLabels.join || "JOIN!" }}
                </button>

                <button
                    v-if="showGameInput"
                    class="back-btn"
                    @click="showGameInput = false"
                >
                    <i class="bi bi-x-lg"></i>
                </button>
            </div>

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
    
    <div
        v-if="showErrorModal"
        class="modal-overlay"
        @click="showErrorModal = false"
    >
        <div class="panel-card" @click.stop>
            <h2>{{ uiLabels.errorTitle || "USER ERROR" }}</h2>

            <p>
                {{
                    uiLabels.serverMissing ||
                    "Impressively incorrect. This node is deader than the code it's running on..."
                }}
            </p>

            <button class="btn-main" @click="showErrorModal = false">
                {{ uiLabels.okButton || "UNDERSTOOD" }}
            </button>
        </div>
    </div>
</template>

<script>
import ResponsiveNav from "@/components/ResponsiveNav.vue";
import LangSwitch from "@/components/LangSwitch.vue";
import socket from "@/clientSocket.js";

export default {
    name: "StartView",
    components: {
        ResponsiveNav,
        LangSwitch,
    },
    data: function () {
        return {
            uiLabels: {},
            newGameId: "",
            lang: localStorage.getItem("lang") || "en",
            showGameInput: false,
            showErrorModal: false,
        };
    },
    created: function () {
        socket.on("uiLabels", (labels) => (this.uiLabels = labels));
        socket.emit("getUILabels", this.lang);
    },
    methods: {
        joinGame: function () {
            if (!this.newGameId) return;

            socket.emit("checkGameExists", this.newGameId);

            socket.once("gameExistsResponse", (exists) => {
                if (exists) {
                    this.$router.push("/lobby/" + this.newGameId);
                } else {
                    this.showErrorModal = true;
                }
            });
        },

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
    padding-top: 4rem;
}

header img {
    width: 60%;
    height: auto;
    max-width: 30rem;
    max-height: 30rem;
    aspect-ratio: 1;
    padding-bottom: 1.5rem;
}

header h1,
h2 {
    color: var(--headline-color);
    text-shadow:
        0 0 10px rgba(255, 215, 0, 0.8),
        0 0 20px rgba(0, 0, 0, 0.9);
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

.button-group {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 1.5rem;
    margin-top: 2rem;
}

.game-input-area {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 1.5rem;
    width: 100%;
}

.back-btn {
    background: var(--button-background-color);
    border: 2px solid var(--button-color);
    color: var(--button-color);
    font-size: 1.5rem;
    font-weight: bold;
    width: 4rem;
    height: 4rem;
    border-radius: 50%;
    cursor: pointer;
    box-shadow: 0 0 12px var(--button-color);
    transition: 0.2s ease;
}
</style>
