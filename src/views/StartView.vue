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
        {{ uiLabels.play || "PLAY!" }}
      </button>

            <div v-else class="poll-input-area">
                <div class="play-btn input-wrapper">
                    <input type="text" v-model="newPollId" :placeholder="uiLabels['gameID'] || 'Game ID'" v-on:keyup.enter="joinGame"/>
                </div>

                <button
                    class="play-btn"
                    @click="$router.push('/lobby/' + newPollId)"
                >
                    {{ uiLabels.join || "JOIN!" }}
                </button>

                <button 
  v-if="showPollInput" 
  class="back-btn"
  @click="showPollInput = false"
>
  X
</button>

      </div>

            <button v-if="!showPollInput" class="play-btn" @click="$router.push('/create')">
                {{ uiLabels["createGame"] || "CREATE!" }}
            </button>
        </div>
    </main>
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

    <div v-if="showErrorModal" class="modal-overlay" @click="showErrorModal = false">
  <div class="modal-content" @click.stop>
    <div class="modal-icon">!</div>
    <h2>{{ uiLabels.errorTitle || "SYSTEMFEL" }}</h2>
    <p>{{ uiLabels.serverMissing || "Servern existerar inte. Kontrollera ID." }}</p>
    <button class="play-btn modal-btn" @click="showErrorModal = false">OK</button>
  </div>
</div>
</template>

<script>
import ResponsiveNav from "@/components/ResponsiveNav.vue";
import FooterComponent from "@/components/FooterComponent.vue";
import socket from "@/socket.js";

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
            showErrorModal: false,
        };
    },
    created: function () {
        socket.on("uiLabels", (labels) => (this.uiLabels = labels));
        socket.emit("getUILabels", this.lang);
    },
    methods: {
        joinGame: function () {
            if (!this.newPollId) return;

            socket.emit('checkPollExists', this.newPollId);

            socket.once('pollExistsResponse', (exists) => {
                if (exists) {
                    this.$router.push('/lobby/' + this.newPollId);
                } else {
                    this.showErrorModal = true;
                }
            });
        },
        
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
    padding-bottom: 1.5rem;
}

header h1,
h2 {
    font-size: 2rem;
    color: var(--headline-color);
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

.poll-input-area {
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

.back-btn:hover {
    transform: scale(1.15);
    box-shadow: 0 0 20px gold;
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


.input-wrapper:hover {
    transform: none;
}

.input-wrapper input {
    background: transparent;
    border: none;
    color: var(--button-color);
 
    font-size: 1.5rem;
    font-weight: bold;
    text-align: center;
    width: 100%;
    height: 100%;
    outline: none;
    font-family: inherit;
    letter-spacing: 2px;

    padding: 0;
}

.input-wrapper input::placeholder {
    color: rgba(255, 215, 0, 0.6);
    text-transform: uppercase;
    font-size: 1.4rem;

}

.modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.85); 
    backdrop-filter: blur(5px); 
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 1000;
}


.modal-content {
    background: linear-gradient(145deg, #0a304c, #0d47a1);
    border: 3px solid gold;
    border-radius: 20px;
    padding: 3rem;
    text-align: center;
    max-width: 400px;
    box-shadow: 0 0 30px rgba(255, 215, 0, 0.4);
    animation: pop-in 0.3s ease-out;
}

.modal-icon {
    font-size: 3rem;
    color: gold;
    margin-bottom: 1rem;
    font-weight: bold;
}

.modal-content h2 {
    color: gold;
    margin-bottom: 1rem;
    text-transform: uppercase;
}

.modal-content p {
    color: white;
    font-size: 1.2rem;
    margin-bottom: 2rem;
}

.modal-btn {
    width: 100% !important;
    height: 3.5rem !important;
    font-size: 1.2rem !important;
}

@keyframes pop-in {
    0% { transform: scale(0.8); opacity: 0; }
    100% { transform: scale(1); opacity: 1; }
}
</style>
