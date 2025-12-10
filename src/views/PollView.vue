<template>
  <div class="poll-view">
    
    <header class="poll-header">
      <h1>Lobby ID: <span class="highlight">{{ pollId }}</span></h1>
    </header>

<div class="info-container">
      <img src="/img/logo.png" alt="Logo" class="poll-logo" />
      
      <h3>
        {{ uiLabels.participants || "Participants" }}: 
        <span class="highlight">{{ participants.length }}</span>
      </h3>

      <div class="participants-grid">
        <div v-for="person in participants" v-bind:key="person.name" class="participant-card">
          {{ person.name }}
        </div>
      </div>
      </div>

    <div class="question-container">
      <QuestionComponent 
        v-bind:question="question"
        v-on:answer="submitAnswer($event)"
      />
    </div>

    <button class="action-btn start-btn">
      START GAME
    </button>

    <span class="debug-text">{{ submittedAnswers }}</span>

  </div>
</template>

<script>
import QuestionComponent from '@/components/QuestionComponent.vue';
import io from 'socket.io-client';
const socket = io("localhost:3000");

export default {
  name: 'PollView',
  components: {
    QuestionComponent
  },
  data: function () {
    return {
      question: {
        q: "",
        a: []
      },
      pollId: "inactive poll",
      submittedAnswers: {},
      participants: [], // Ny array för deltagare
      uiLabels: {}
    }
  },
  created: function () {
    this.pollId = this.$route.params.id;
    
    socket.on( "questionUpdate", q => this.question = q );
    socket.on( "submittedAnswersUpdate", answers => this.submittedAnswers = answers );
    socket.on( "uiLabels", labels => this.uiLabels = labels );
    
    // NYTT: Lyssna på deltagare så vi kan räkna dem
    socket.on( "participantsUpdate", p => this.participants = p );

    socket.emit( "getUILabels", this.lang );
    socket.emit( "joinPoll", this.pollId );
  },
  methods: {
    submitAnswer: function (answer) {
      socket.emit("submitAnswer", {pollId: this.pollId, answer: answer})
    }
  }
}
</script>

<style scoped>
/* Grundlayout (Samma som Lobby) */
.poll-view {
  background-color: var(--background-color, #3a0b3a); /* Fallback färg */
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
  text-shadow: 0 2px 4px rgba(0,0,0,0.8);
}

.highlight {
  color: gold;
  font-weight: bold;
}

.info-container {
  text-align: center;
  margin-bottom: 2rem;
}

.poll-logo {
  width: 120px; /* Lite mindre logga här än i lobbyn */
  height: auto;
  margin-bottom: 1rem;
}



/* Snygg knapp (Samma som Lobby) */
.action-btn {
  background: linear-gradient(145deg, #311b92, #512da8);
  color: gold;
  font-size: 1.5rem;
  font-weight: bold;
  padding: 15px 50px;
  border: 3px solid gold;
  border-radius: 50px;
  cursor: pointer;
  transition: transform 0.2s, box-shadow 0.2s;
  text-transform: uppercase;
  letter-spacing: 2px;
  box-shadow: 0 0 15px rgba(255, 215, 0, 0.5);
}

.action-btn:hover {
  transform: scale(1.05);
  box-shadow: 0 0 25px gold;
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
  font-size: 0.9rem; /* Lite mindre text än i lobbyn */
  font-weight: bold;
  box-shadow: 0 2px 4px rgba(0,0,0,0.3);
}
</style>