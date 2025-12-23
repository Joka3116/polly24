<template>
  <div class="poll-view">

    <header class="poll-header">
      <h1>Lobby ID: <span class="highlight">{{ pollId }}</span></h1>
    </header>

    <div class="info-container">
      <img src="/img/logo.png" alt="Logo" class="poll-logo" />

      <div class="timer-wrapper" v-if="question.text && !showResults">
        <h2 :class="{ 'critical': timer < 10 }">TID KVAR: {{ timer }}s</h2>
        <div class="timer-bar" :style="{ width: (timer / 60) * 100 + '%' }"></div>

        <div class="answers-count">
          <h3>SVAR: <span class="highlight">{{ answersStatus.answered }}</span></h3>
        </div>
      </div>
    </div>

    <div class="question-container">
      <div v-if="question.text">
        <QuestionComponent v-bind:question="question" v-bind:isHost="isHost" v-bind:showResults="showResults"
          v-bind:timeExpired="timeExpired" v-on:answer="submitAnswer($event)" />

        <div v-if="isHost" class="host-controls">
          <button v-if="!showResults" class="btn-main" @click="revealAnswer">VISA SVAR</button>
          <button v-else class="btn-main" @click="runNextQuestion">NÄSTA FRÅGA</button>
        </div>
      </div>

      <div v-else class="waiting-screen">
        <h2 v-if="!isHost">Väntar på fråga...</h2>
        <div v-else>
          <h2>Redo att starta?</h2>
          <button class="btn-main" @click="runNextQuestion">START GAME</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import QuestionComponent from '@/components/QuestionComponent.vue';
import socket from "@/socket.js";

export default {
  name: 'PollView',
  components: {
    QuestionComponent
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
      answersStatus: { answered: 0, total: 0 }
    }
  },

  created: function () {
    this.pollId = this.$route.params.id;
    this.isHost = localStorage.getItem("isHost") === "true";

    socket.on("questionUpdate", q => {
      this.question = q;
      this.showResults = false;
    });

    socket.on("showResults", () => {
      this.showResults = true;
    });

    socket.on("hideResults", () => {
      this.showResults = false;
    });

    socket.on("timerUpdate", t => {
      this.timer = t;
      this.timeExpired = (t <= 0);
    });

    socket.on("hideResults", () => {
      this.showResults = false;
      this.timeExpired = false;
    });

    socket.on("submittedAnswersUpdate", answers => this.submittedAnswers = answers);
    socket.on("uiLabels", labels => this.uiLabels = labels);
    socket.on("participantsUpdate", p => this.participants = p);

    socket.emit("getUILabels", this.lang);
    socket.emit("joinPoll", this.pollId);

    socket.on("answersUpdate", (status) => {
      this.answersStatus = status;
    });


    socket.on("questionUpdate", q => {
      this.question = q;
      this.showResults = false;
      this.answersStatus.answered = 0;
    });
  },
  methods: {
submitAnswer: function (answerObject) { 
  const user = localStorage.getItem("userName");
  
 
  const answerText = answerObject.text || answerObject; 

  socket.emit("submitAnswer", {
    pollId: this.pollId,
    answer: answerText,
    userName: user,
    timeLeft: this.timer
  });
},

    runNextQuestion: function () {
      socket.emit("runQuestion", { pollId: this.pollId });
    },
    revealAnswer: function () {
      socket.emit("showResults", { pollId: this.pollId });
    }
  }
}

</script>

<style scoped>
.poll-view {
  background-color: var(--background-color, #3a0b3a);

  min-height: 100vh;
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
</style>