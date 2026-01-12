<template>
  <TopRightHeader />
  <header>
    <h1>{{ uiLabels.createGame || "CREATE!" }}</h1>
    <p>{{ uiLabels.createSubTitle || "Här kan du skapa ett spel" }}</p>
  </header>
  <main>
    <div class="create-container">

      <LobbyLicensePlate :pollId="pollId" />

      <div class="selection-wrapper">
        <h3>{{ uiLabels.difficultyLevel || "Välj Svårighetsgrad" }}</h3>

        <div class="button-row">
          <button v-on:click="selectedDifficulty = 'easy'"
            v-bind:class="['option-btn', { selected: selectedDifficulty === 'easy' }]">
            {{ uiLabels.easy || "Easy" }}
          </button>
          <button v-on:click="selectedDifficulty = 'medium'"
            v-bind:class="['option-btn', { selected: selectedDifficulty === 'medium' }]">
            {{ uiLabels.medium || "Medium" }}
          </button>
          <button v-on:click="selectedDifficulty = 'hard'"
            v-bind:class="['option-btn', { selected: selectedDifficulty === 'hard' }]">
            {{ uiLabels.hard || "Hard" }}
          </button>
        </div>
      </div>

      <div class="selection-wrapper">
        <h3>{{ uiLabels.numOfQuestions || "Antal Frågor" }}</h3>
        <div class="button-row">
          <button v-for="num in [5, 7, 10]" v-bind:key="num" v-on:click="selectedNrOfQuestions = num"
            v-bind:class="['option-btn', { selected: selectedNrOfQuestions === num }]">
            {{ num }}
          </button>
        </div>
      </div>

      <button v-on:click="createPollSettings" class="start-btn">
        <span>{{ uiLabels.createGameNow || "CREATE!" }}</span>
        <span style="font-size:0.8rem;padding: 0;">{{ selectedNrOfQuestions }} {{ difficultyLabel }} {{
          uiLabels.questions || "questions" }}</span>
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
    <router-link to="/">
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
import TopRightHeader from "@/components/TopRightHeader.vue";
import LobbyLicensePlate from "@/components/LobbyLicensePlate.vue";

export default {
  name: 'CreateView',
  components: {
    ResponsiveNav,
    LangSwitch,

    TopRightHeader,
    LobbyLicensePlate,
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
      selectedDifficulty: 'easy', // Förvald svårighetsgrad
      selectedNrOfQuestions: 5    // Förvalt antal frågor
    }
  },
  created: function () {
    this.pollId = Math.floor(100000 + Math.random() * 900000);
    socket.on("uiLabels", labels => this.uiLabels = labels);
    socket.on("pollData", data => this.pollData = data);
    socket.on("participantsUpdate", p => this.pollData.participants = p);
    socket.emit("getUILabels", this.lang);
    this.createPoll();
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
    createPoll: function () {
      socket.emit("createPoll", { pollId: this.pollId, lang: this.lang })
      socket.emit("joinPoll", this.pollId);
    },
    createPollSettings() {
      // 1. Spara inställningar på servern utan att starta frågor än
      socket.emit("saveSettings", {
        pollId: this.pollId,
        difficulty: this.selectedDifficulty,
        nrOfQuestions: this.selectedNrOfQuestions
      });

      localStorage.setItem("isHost", "true");
      // 2. Gå till lobbyn för att vänta på deltagare
      this.$router.push(`/lobby/${this.pollId}`);
    },
  },
  computed: {
    difficultyLabel() {
      if (this.selectedDifficulty === 'easy') return this.uiLabels.easyQuestions || 'easy';
      if (this.selectedDifficulty === 'medium') return this.uiLabels.mediumQuestions || 'medium';
      if (this.selectedDifficulty === 'hard') return this.uiLabels.hardQuestions || 'hard';
      return this.selectedDifficulty;
    }
  },
  addQuestion: function () {
    socket.emit("addQuestion", { pollId: this.pollId, q: this.question, a: this.answers })
  },
  addAnswer: function () {
    this.answers.push("");
  },
  runQuestion: function () {
    socket.emit("runQuestion", { pollId: this.pollId, questionNumber: this.questionNumber })
  }
}
</script>

<style scoped>
header {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding-top: clamp(8rem, 8dvh, 10rem);
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

h3 {
  font-size: 2.5rem;
  text-wrap: nowrap;
}

header p {
  color: var(--headline-color);
  text-align: center;
  margin: 0;
  padding: 0;
  font-size: 1.5rem;
}

.create-container {
  color: var(--headline-color);
  padding: 2em;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.selection-wrapper {
  margin-top: 0.5rem;
  margin-bottom: 1rem;
  width: 100%;
  max-width: 600px;
}

.button-row {
  margin-top: 0.5rem;
  display: flex;
  justify-content: center;
  gap: 2rem;
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
  display: flex !important;
  justify-content: center !important;
  align-items: center !important;
}

.option-btn.selected {
  background: radial-gradient(circle, #1b9238, #0f521d);
  opacity: 1;
  transform: scale(1.1);
  box-shadow: 0 0 20px gold;
  border-color: white;
}

.start-btn {
  margin-top: 3rem;
  padding: 1.25rem 2.5rem;
  font-size: 2rem;
  letter-spacing: 3px;
  text-transform: uppercase;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0;
  line-height: 1;
  text-wrap: nowrap;
}

button:hover {
  transform: scale(1.05);
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