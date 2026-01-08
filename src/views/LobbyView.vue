<template>
  <div class="lobby-view">
    <header class="lobby-header">
      <h1>Lobby ID: <span class="highlight">{{ pollId }}</span></h1>
    </header>

    <div v-if="!joined" class="join-container panel-card">
      <h2>{{ uiLabels.participateInPoll || "Enter Name" }}</h2>
      <input 
        type="text" 
        class="input-main" 
        v-model="userName" 
        :placeholder="uiLabels['name'] || 'NAME'"
        v-on:keyup.enter="participateInPoll"
      >
      <button class="btn-main" v-on:click="participateInPoll" :disabled="userName.length < 1">
        {{ uiLabels["join"] || "JOIN" }}
      </button>
    </div>

    <div v-if="joined" class="waiting-container">
      <img src="/img/logo.png" alt="Logo" class="lobby-logo" />

      <h2 v-if="!isHost">
        {{ uiLabels.welcome || "Welcome" }}
        <span class="highlight">{{ userName }}</span>!
      </h2>

      <button 
        v-if="!isHost" 
        class="btn-main" 
        :class="{ 'btn-alt': isReady }" 
        v-on:click="toggleReady">
        {{ isReady ? (uiLabels.notReady || "INTE REDO") : (uiLabels.ready || "REDO") }}
      </button>

      <div v-if="isHost" class="host-controls">
        <button class="btn-main" v-on:click="runQuiz">
          STARTA SPELET
        </button>
      </div>

      <h3 v-if="!isHost" class="pulsing-text">
        {{ isReady ? "AWAITING INITIATION..." : "CONFIRM PRESENCE, OPERATOR." }}
      </h3>

      <h3>{{ uiLabels.participants || "Deltagare" }}: {{ participants.length }}</h3>

      <div class="participants-grid">
        <div v-for="(participant, index) in participants" :key="index" class="participant-card" :class="{
          'is-me': participant.name === userName,
          'ready': participant.isReady
        }">
          {{ participant.name }}
        </div>
      </div>
    </div>

    <div v-if="showErrorModal" class="modal-overlay" @click="showErrorModal = false">
      <div class="panel-card" @click.stop>
        <h2>{{ errorTitle }}</h2>
        <p>{{ errorMessage }}</p>
        <button class="btn-main" @click="showErrorModal = false">
          {{ uiLabels.okButton || "UPPFATTAT" }}
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import socket from "@/socket.js";


export default {
  name: 'LobbyView',
  data: function () {
    return {
      userName: "",
      pollId: "inactive poll",
      uiLabels: {},
      joined: false,
      isReady: false,
      lang: localStorage.getItem("lang") || "en",
      participants: [],
      isHost: false,
      showErrorModal: false,
      errorTitle: "",
      errorMessage: "",

    }
  },
computed: {
    displayParticipants() {
      // Ganska stor ändring här för att programmet ska godkänna unika användarnamn. 
      return this.participants;
    }
  },

  created: function () {
    this.pollId = this.$route.params.id;
    this.isHost = localStorage.getItem("isHost") === "true";

  
    if (this.isHost) {
      this.joined = true;
      this.userName = "Host"; 
    }


    socket.on("uiLabels", labels => this.uiLabels = labels);

    socket.on("participantsUpdate", p => {
      this.participants = [...p];
    });

  socket.on("startPoll", () => {
  // Endast deltagare ska tvingas vidare automatiskt
  if (!this.isHost) {
    this.$router.push("/poll/" + this.pollId);
  }
});
    socket.emit("joinPoll", this.pollId);
    socket.emit("getUILabels", this.lang);

    socket.on("joinSuccess", () => {
  this.joined = true;
});

socket.on("nameTaken", (error) => {
this.errorTitle = this.uiLabels.nameErrorTitle || "IDENTITY THEFT";
  this.errorMessage = this.uiLabels.nameTakenMsg || "This operator profile is already active in the node. The Billionaire Engine permits no digital clones. Choose a unique designation or vacate the premises."
  this.showErrorModal = true;
  this.joined = false;
});

socket.on("navToPoll", (id) => {
  if (!this.isHost) {
    this.$router.push("/poll/" + id);
  }
});
  },
  methods: {
    participateInPoll: function () {
      if (this.userName.length > 0) {
        localStorage.setItem("userName", this.userName);
        socket.emit("participateInPoll", { pollId: this.pollId, name: this.userName })

      }
    },
    toggleReady: function () {
      this.isReady = !this.isReady;
      socket.emit("playerReady", {
        pollId: this.pollId,
        name: this.userName,
        isReady: this.isReady
      });
    }, 
    
runQuiz: function() {
  // Säg till servern att flytta alla deltagare
  socket.emit("initiateGameNavigation", { pollId: this.pollId });
  // Flytta hosten direkt
  this.$router.push("/poll/" + this.pollId);
}
  }
}
</script>

<style scoped>
.lobby-view {
  background-color: var(--background-color);
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  color: white;
  font-family: 'Arial', sans-serif;
  padding: 20px;
}

.lobby-header {
  margin-top: 2rem;
  margin-bottom: 1rem;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.8);
}

.highlight {
  color: gold;
  font-weight: bold;
  text-transform: uppercase;
}

.lobby-logo {
  width: 180px;
  height: auto;
  margin-bottom: 1rem;
  animation: float 6s ease-in-out infinite;
}

@keyframes float {
  0% {
    transform: translateY(0px);
  }

  50% {
    transform: translateY(-10px);
  }

  100% {
    transform: translateY(0px);
  }
}

.join-container {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
  align-items: center;
}

.waiting-container {
  width: 100%;
  max-width: 800px;
  text-align: center;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 2rem; 
  padding: 20px 0;
}

.pulsing-text {
  animation: pulse 2s infinite;
  margin-bottom: 1rem;
  color: gold;
  font-style: italic;
}

@keyframes pulse {
  0% {
    opacity: 0.6;
  }

  50% {
    opacity: 1;
  }

  100% {
    opacity: 0.6;
  }
}

.participants-grid {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: 15px;
  width: 100%;
}


.participant-card {

  background: grey;
  border: 2px solid #bbb;
  border-radius: 50px;
  padding: 8px 20px;
  color: white;
  font-weight: bold;
  font-size: 1rem;
  min-width: 100px;
  text-align: center;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.3);
  transition: background 0.3s, transform 0.2s;
  animation: popIn 0.3s ease-out;
}


.participant-card.is-me {
  border-color: gold;
  color: white;
  transform: scale(1.05);
  box-shadow: 0 0 10px gold;
 
}

.participant-card.ready {
  background: linear-gradient(145deg, #2e7d32, #43a047) !important;
  border-color: #2e7d32;
}

.join-container .btn-main {
    width: auto !important;        
    min-width: 160px !important;    
    font-size: 2rem !important;   
    align-self: center;
}
</style>