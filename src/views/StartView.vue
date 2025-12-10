<template>
    <header>
        <img src="/img/logo.png" alt="Logo" />
        <h1>{{ uiLabels["sales-pitch"] }}</h1>
        <h2>{{ uiLabels.subHeading }}</h2>
    </header>
    <main>
        <label>
            Write poll id:
            <input type="text" v-model="newPollId" />
        </label>
        <router-link v-bind:to="'/lobby/' + newPollId">
            {{ uiLabels.participatePoll }}
        </router-link>
        <div class="play-container">
            <button class="play-btn" @click="$router.push('/create')">
                PLAY
            </button>
        </div>
    </main>
    <footer>
        <p>&copy; 2025 Polly24</p>
    </footer>
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
import io from "socket.io-client";
const socket = io("localhost:3000");

export default {
    name: "StartView",
    components: {
        ResponsiveNav,
    },
    data: function () {
        return {
            uiLabels: {},
            newPollId: "",
            lang: localStorage.getItem("lang") || "en",
            hideNav: true,
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
    background-color: #3a0b3a;
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
    background-color: #3a0b3a;
    color: white;
    min-height: 30rem;
    padding-top: 5rem;
}
main a {
    color: white;
}

.play-container {
    margin-top: 2rem;
    display: flex;
    justify-content: center;
}

.play-btn {
    background: radial-gradient(circle, #512da8, #311b92);
    color: gold;
    padding: 12px 40px;
    font-size: 1.8rem;
    font-weight: bold;
    border: 3px solid gold;
    border-radius: 30px;
    letter-spacing: 3px;
    cursor: pointer;
    box-shadow: 0 0 15px gold;
    transition: 0.2s ease;
}

.play-btn:hover {
    transform: scale(1.1);
    box-shadow: 0 0 25px gold;
}

footer {
    padding: 3rem;
    background-color: #ff8db1;
    text-align: left;
}

footer p {
    color: #3a0b3a;
}
</style>
