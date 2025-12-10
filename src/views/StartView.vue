<template>
  <header>
    <img src="/img/logo.png" alt="Logo" />
    <h1>{{ uiLabels["sales-pitch"] }}</h1>
    <h2>{{ uiLabels.subHeading }}</h2>
  </header>
  <main>
    <div class="button-group">
      
      <button 
        v-if="!showPollInput" 
        class="play-btn" 
        @click="showPollInput = true">
        {{ uiLabels.play || "PLAY" }}
      </button>

            <div v-else class="poll-input-area">
                <div class="play-btn input-wrapper">
                    <input
                        type="text"
                        v-model="newPollId"
                        :placeholder="uiLabels['gameID'] || 'Game ID'"
                    />
                </div>

                <button class="play-btn" @click="$router.push('/lobby/' + newPollId)">
                    {{ uiLabels.join || "JOIN" }}
                </button>
      </div>

            <button
                v-if="!showPollInput"
                class="play-btn"
                @click="$router.push('/create')"
            >
                {{ uiLabels["createGame"] || "CREATE GAME" }}
            </button>
        </div>
    </main>
    <FooterComponent></FooterComponent>
    <ResponsiveNav>
        <button v-on:click="switchLanguage">
            {{ uiLabels.changeLanguage }}
        </button>
        <router-link to="/create/">
            {{ uiLabels.createPoll }}
        </router-link>
        <a href="#">
            {{ uiLabels.about }}
        </a>
        <a href="#">FAQ</a>
    </ResponsiveNav>
</template>

<script>
import ResponsiveNav from "@/components/ResponsiveNav.vue";
import FooterComponent from "@/components/FooterComponent.vue";
import io from "socket.io-client";
const socket = io("localhost:3000");

export default {
    name: "StartView",
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
*,
body,
main,
header {
    margin: 0;
    padding: 0;
}

body {
    height: 100%;
}

header {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding-top: 3rem;
    background-color: var(--background-color);
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
    background-color: var(--background-color);
    color: white;
    min-height: 30rem;
    padding-top: 5rem;
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

.poll-input-area {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 1.5rem;
    width: 100%;
}

.play-btn {
    background: var(--button-background-color);
    color: var(--button-color);
    padding: 12px 0;
    font-size: 1.8rem;
    font-weight: bold;
    border: 3px solid var(--button-color);
    border-radius: 30px;
    cursor: pointer;
    box-shadow: 0 0 15px var(--button-color);
    transition: 0.2s ease;

    width: 14rem;
    height: 4rem;
    display: flex;
    justify-content: center;
    align-items: center;
    letter-spacing: 2px;
}

.play-btn:hover {
    transform: scale(1.1);
    box-shadow: 0 0 25px var(--button-color);
}

.input-wrapper {
    cursor: text;
}

/* Ta bort hover-effekt på just input-rutan */
.input-wrapper:hover {
    transform: none;
}

.input-wrapper input {
    background: transparent;
    border: none;
    color: var(--button-color);
    /* Minskad font-storlek för att få plats bättre */
    font-size: 1.5rem;
    font-weight: bold;
    text-align: center;
    width: 100%;
    height: 100%;
    outline: none;
    font-family: inherit;
    letter-spacing: 2px;
    /* Nollställ padding för att undvika att texten klipps */
    padding: 0;
}

.input-wrapper input::placeholder {
    color: rgba(255, 215, 0, 0.6);
    text-transform: uppercase;
    font-size: 1.4rem; /* Något mindre font på placeholdern om den är lång */
}
</style>
