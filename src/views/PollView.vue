<template>
  <TopRightHeader />
  <header>
    <h1>{{ uiLabels.playpoll || "PLAY AND WIN!" }}</h1>
  </header>
  <main>

    <div class="poll-view">

      <LobbyLicensePlate :pollId="pollId" class="desktop-only" />

      <div class="info-container">
        <img src="/img/logo.png" alt="Logo" class="poll-logo" />

        <div v-if="isHost && question.text" class="question-count-display">
          <h2>{{ uiLabels.question }}: <span class="highlight">{{ question.currentNumber }} / {{ question.totalQuestions
          }}</span></h2>
        </div>

        <div class="timer-wrapper" v-if="question.text && !showResults">
          <h2 :class="{ 'critical': timer < 10 }">{{ uiLabels.timer }} {{ timer }}s</h2>
          <div class="timer-bar" :style="{ width: (timer / 60) * 100 + '%' }"></div>

          <div class="answers-count">
            <h3>{{ uiLabels.answer }}: <span class="highlight">{{ answersStatus.answered }}</span></h3>
          </div>
        </div>
      </div>

      <div class="question-container">
        <div v-if="question.text">
          <QuestionComponent v-bind:question="question" v-bind:isHost="isHost" v-bind:showResults="showResults"
            v-bind:timeExpired="timeExpired" v-bind:correctAnswerId="correctAnswerId"
            v-on:answer="submitAnswer($event)" />

          <div v-if="isHost" class="host-controls">
            <button v-if="!showResults" class="btn-main" @click="revealAnswer">
              {{ uiLabels.showanswer }}
            </button>

            <button v-else-if="question.currentNumber < question.totalQuestions" class="btn-main"
              @click="runNextQuestion">
              {{ uiLabels.nextQ }}
            </button>
          </div>

        </div>

        <div v-else class="waiting-screen">
          <h2 v-if="!isHost">{{ uiLabels.waiting }}</h2>
          <div v-else>
            <h2>{{ uiLabels.readyStart }}</h2>
            <button class="btn-main" @click="runNextQuestion">{{ uiLabels.startGame }}</button>
          </div>
        </div>
      </div>
    </div>
  </main>
  <ResponsiveNav>
    <router-link to="/about/">
      {{ uiLabels.about || "ABOUT!" }}
    </router-link>
    <router-link to="/faq/">
      {{ uiLabels.faq || "FAQ!" }}
    </router-link>
    <router-link to="/l">
      {{ uiLabels.play || "PLAY!" }}
    </router-link>
    <router-link to="/create/">
      {{ uiLabels["createGame"] || "CREATE!" }}
    </router-link>
    <LangSwitch @switch-language="switchLanguage" />
  </ResponsiveNav>
</template>

<script>
import QuestionComponent from '@/components/QuestionComponent.vue';
import socket from "@/socket.js";
import ResponsiveNav from "@/components/ResponsiveNav.vue";
import TopRightHeader from "@/components/TopRightHeader.vue";
import LangSwitch from "@/components/LangSwitch.vue";
import LobbyLicensePlate from "@/components/LobbyLicensePlate.vue";

export default {
  name: 'PollView',
  components: {
    QuestionComponent,
    ResponsiveNav,
    TopRightHeader,
    LangSwitch,
    LobbyLicensePlate
  },
  data: function () {
    return {
      lang: localStorage.getItem("lang") || "en",
      question: { text: "", answers: [] },
      pollId: "inactive poll",
      submittedAnswers: {},
      participants: [],
      uiLabels: {},
      isHost: false,
      showResults: false,
      timer: 0,
      timeExpired: false,
      answersStatus: { answered: 0, total: 0 },
      correctAnswerId: null,
      isGameOver: false,
      gameOverTimeout: null
    }
  },

  beforeUnmount() {
    socket.off("questionUpdate");
    socket.off("showResults");
    socket.off("timerUpdate");
    socket.off("hideResults");
    socket.off("submittedAnswersUpdate");
    socket.off("participantsUpdate");
    socket.off("answersUpdate");
    socket.off("uiLabels");

    if (this.gameOverTimeout) {
      clearTimeout(this.gameOverTimeout);
    }
  },

  created: function () {
    this.pollId = this.$route.params.id;
    this.isHost = localStorage.getItem("isHost") === "true";

    socket.on("questionUpdate", q => {
      this.question = q || { text: "", answers: [] };
      this.showResults = false;
      this.answersStatus.answered = 0;
      this.isGameOver = false;
    });


    socket.on("showResults", (correctId) => {
      if (correctId !== undefined) {
        this.correctAnswerId = correctId;
      }
      this.showResults = true;
    });


    socket.on("timerUpdate", t => {
      this.timer = t;
      this.timeExpired = (t <= 0);
    });

    socket.on("hideResults", () => {
      this.showResults = false;
      this.timeExpired = false;
    });

    socket.on("gameOver", () => {
      this.isGameOver = true;
      this.showResults = true;

      this.gameOverTimeout = setTimeout(() => {
        this.$router.push(`/result/${this.pollId}`);
      }, 2000);
    });

    socket.on("submittedAnswersUpdate", answers => this.submittedAnswers = answers);
    socket.on("uiLabels", labels => {
      this.uiLabels = { ...labels };
    });
    socket.on("participantsUpdate", p => this.participants = p);

    socket.emit("getUILabels", this.lang);
    socket.emit("joinPoll", this.pollId);

    socket.on("answersUpdate", (status) => {
      this.answersStatus = status;
    });
  },
  methods: {
    submitAnswer: function (answerObject) {
      const user = localStorage.getItem("userName");


      socket.emit("submitAnswer", {
        pollId: this.pollId,
        answerId: answerObject.id, // Ändrat från 'answer' till 'answerId'
        userName: user,
        timeLeft: this.timer
      });
    },
    runNextQuestion: function () {

      if (!this.question || this.question.text === "") {
        socket.emit("startPoll", { pollId: this.pollId, language: this.lang });
      } else {
        socket.emit("runQuestion", { pollId: this.pollId });
      }
    },
    revealAnswer: function () {
      socket.emit('forceEndQuestion', { pollId: this.pollId });
    },

    switchLanguage: function (lang) {
      this.lang = lang;
      localStorage.setItem("lang", this.lang);

      socket.emit("getUILabels", this.lang);

      socket.emit("patchCurrentQuestion", {
        pollId: this.pollId,
        lang: this.lang
      });
    }
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

.poll-view {
  display: flex;
  flex-direction: column;
  align-items: center;
  color: white;
  font-family: 'Arial', sans-serif;
  padding: 20px;
}

.poll-header {
  margin-top: 1rem;
  margin-bottom: 2rem;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.8);
}

.highlight {
  color: gold;
  font-weight: bold;
}

.info-container {
  text-align: center;
  margin-bottom: 3rem;

}

.poll-logo {
  width: 120px;

  height: auto;
  margin-bottom: 1rem;
}

.debug-text {
  margin-top: 2rem;
  font-size: 0.8rem;
  color: #aaa;
}

.participants-grid {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: 10px;
  margin-top: 10px;
  margin-bottom: 20px;
  width: 100%;
  max-width: 800px;
}

.participant-card {
  background: linear-gradient(145deg, #0d47a1, #1565c0);
  border: 1px solid #4fc3f7;
  border-radius: 20px;
  padding: 5px 15px;
  color: white;
  font-size: 0.9rem;
  /* Lite mindre text än i lobbyn */
  font-weight: bold;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
}


.timer-wrapper {
  margin: 1rem 0;
  color: gold;
}

.timer-wrapper h2.critical {
  color: #ff3e3e;
  animation: pulse 0.5s infinite;
}

.timer-bar {
  height: 8px;
  background: linear-gradient(90deg, gold, orange);
  border-radius: 4px;
  transition: width 1s linear;
  box-shadow: 0 0 10px rgba(255, 215, 0, 0.5);
  margin: 0 auto;
  max-width: 300px;
}

@keyframes pulse {
  0% {
    transform: scale(1);
  }

  50% {
    transform: scale(1.1);
  }

  100% {
    transform: scale(1);
  }
}

.answers-count {
  margin-top: 1rem;
  text-transform: uppercase;
  letter-spacing: 2px;
}

.answers-count h3 {
  font-size: 1.4rem;
}

.question-count-display {
  margin-bottom: 0.5rem;
  text-transform: uppercase;
  letter-spacing: 2px;
}

.question-count-display h2 {
  font-size: 1.8rem;
  text-shadow: 0 0 10px rgba(255, 215, 0, 0.5);
}

@media (max-width: 600px) {
  .desktop-only {
    display: none;
  }

  .header,
  h1 {
    display: none;
  }
}
</style>