<template>
    <div class="create-container">
        <h1>Inställningar</h1>

        <h3>
            Lobby ID <br />
            <span class="lobby-code">{{ pollId }}</span>
        </h3>

        <div class="selection-wrapper">
            <h3>Välj Svårighetsgrad:</h3>

            <div class="button-row">
                <button
                    v-on:click="selectedDifficulty = 'easy'"
                    v-bind:class="[
                        'option-btn',
                        { selected: selectedDifficulty === 'easy' },
                    ]"
                >
                    Easy
                </button>
                <button
                    v-on:click="selectedDifficulty = 'medium'"
                    v-bind:class="[
                        'option-btn',
                        { selected: selectedDifficulty === 'medium' },
                    ]"
                >
                    Medium
                </button>
                <button
                    v-on:click="selectedDifficulty = 'hard'"
                    v-bind:class="[
                        'option-btn',
                        { selected: selectedDifficulty === 'hard' },
                    ]"
                >
                    Hard
                </button>
            </div>
        </div>

        <div class="selection-wrapper">
            <h3>Antal Frågor:</h3>
            <div class="button-row">
                <button
                    v-for="num in [5, 7, 10]"
                    v-bind:key="num"
                    v-on:click="selectedNrOfQuestions = num"
                    v-bind:class="[
                        'option-btn',
                        { selected: selectedNrOfQuestions === num },
                    ]"
                >
                    {{ num }}
                </button>
            </div>
        </div>

        <button v-on:click="startPoll" class="start-btn">START POLL</button>

        <div style="margin-top: 20px; font-size: 0.8rem">
            Valt: {{ selectedDifficulty }}, {{ selectedNrOfQuestions }} frågor
        </div>
    </div>
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
        <router-link to="/lobby/1">
            {{ uiLabels.play || "PLAY!" }}
        </router-link>
        <router-link to="/create/">
            {{ uiLabels["createGame"] || "CREATE!" }}
        </router-link>
        <LangSwitch @switch-language="switchLanguage" />  
    </ResponsiveNav>
</template>

<script>
import socket from "@/socket.js";
import ResponsiveNav from "@/components/ResponsiveNav.vue";
import LangSwitch from "@/components/LangSwitch.vue";

export default {
    name: "CreateView",
    components: {
        ResponsiveNav,
        LangSwitch,
    },
    data: function () {
        return {
            lang: localStorage.getItem("lang") || "en",
            pollId: "",
            question: "",
            answers: ["", ""],
            questionNumber: 0,
            pollData: {},
            uiLabels: {},
            // NY DATA HÄR:
            selectedDifficulty: "easy", // Förvald svårighetsgrad
            selectedNrOfQuestions: 5, // Förvalt antal frågor
        };
    },
    created: function () {
        this.pollId = Math.floor(100000 + Math.random() * 900000);
        socket.on("uiLabels", (labels) => (this.uiLabels = labels));
        socket.on("pollData", (data) => (this.pollData = data));
        socket.on(
            "participantsUpdate",
            (p) => (this.pollData.participants = p),
        );
        socket.emit("getUILabels", this.lang);
        this.createPoll();
    },
    methods: {
        createPoll: function () {
            socket.emit("createPoll", { pollId: this.pollId, lang: this.lang });
            socket.emit("joinPoll", this.pollId);
        },
        startPoll() {
            // 1. Skicka inställningarna till servern
            socket.emit("startPoll", {
                pollId: this.pollId,
                difficulty: this.selectedDifficulty,
                nrOfQuestions: this.selectedNrOfQuestions,
            });

            // 2. VIKTIGT: Spara att denna klient är HOST
            // Detta behövs för att GameView ska veta att den ska visa frågorna
            localStorage.setItem("isHost", "true");

            // 3. Navigera till lobbyn (eller direkt till spelet om du föredrar)
            // Enligt din plan: "när hosten trycker på 'start poll' så skickas den in i lobbyn"
            this.$router.push(`/lobby/${this.pollId}`);
        },
        switchLanguage: function (lang) {
            if (lang) {
               this.lang = lang;
            } else {
                this.lang = this.lang === "en" ? "sv" : "en";
            }
            localStorage.setItem("lang", this.lang);
            socket.emit("getUILabels", this.lang);
        },
    },
    addQuestion: function () {
        socket.emit("addQuestion", {
            pollId: this.pollId,
            q: this.question,
            a: this.answers,
        });
    },
    addAnswer: function () {
        this.answers.push("");
    },
    runQuestion: function () {
        socket.emit("runQuestion", {
            pollId: this.pollId,
            questionNumber: this.questionNumber,
        });
    },
};
</script>

<style scoped>
.create-container {
    min-height: 100vh;
    color: white;
    padding: 2em;
    display: inherit;
    flex-direction: inherit;
    align-items: center;
}

h1,
h2,
h3 {
    text-align: center;
    color: gold;
    margin-bottom: 0.3rem;
}

h4 {
    text-align: center;
    color: white;
    font-size: 4rem;
}

.selection-wrapper {
    margin-bottom: 1rem;
    width: 100%;
    max-width: 600px;
}

.button-row {
    display: flex;
    justify-content: center;
    gap: 1rem;
}

button {
    cursor: pointer;
    font-weight: bold;
    color: gold;
    border: 3px solid gold;
    border-radius: 30px;
    background: radial-gradient(circle, #512da8, #311b92);
    transition: 0.2s ease;
    box-shadow: 0 0 10px gold;
}

.option-btn {
    padding: 10px 20px;
    font-size: 1.2rem;
    min-width: 80px;
    opacity: 0.6;
}

.option-btn.selected {
    background: radial-gradient(circle, #1b9238, #0f521d);
    opacity: 1;
    transform: scale(1.1);
    box-shadow: 0 0 20px gold;
    border-color: white;
}

.start-btn {
    margin-top: 30px;
    padding: 20px 60px;
    font-size: 2rem;
    letter-spacing: 3px;
    text-transform: uppercase;
    display: block;
}

button:hover {
    transform: scale(1.05);
}

header {
    font-size: 2rem;
}

.lobby-code {
    font-size: 3rem;
    color: white;
    letter-spacing: 5px;
    background: rgba(0, 0, 0, 0.3);
    padding: 10px 25px;
    border-radius: 15px;
    border: 2px solid gold;
    display: inline-block;
    margin-top: 5px;
    margin-bottom: 20px;
    text-shadow: 2px 2px 0px #000;
    box-shadow: 0 0 15px rgba(255, 215, 0, 0.3);
}
</style>
