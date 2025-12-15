<template>
  <div class="lobby-view">
    <header class="lobby-header">
      <h1>Lobby ID: <span class="highlight">{{ pollId }}</span></h1>
    </header>

    <div v-if="!joined" class="join-container">
      <h2>{{ uiLabels.participateInPoll || "Enter Name" }}</h2>

      <div class="input-wrapper">
        <input type="text" v-model="userName" :placeholder="uiLabels['name'] || 'NAME'"
          v-on:keyup.enter="participateInPoll">
      </div>

      <button class="action-btn" v-on:click="participateInPoll" :disabled="userName.length < 1">
        {{ uiLabels["join"] || "JOIN" }}
      </button>
    </div>

    <div v-if="joined" class="waiting-container">
      <img src="/img/logo.png" alt="Logo" class="lobby-logo" />

      <h2>
        {{ uiLabels.welcome || "Welcome" }}
        <span class="highlight">{{ userName }}</span>!
      </h2>

      <h3 class="pulsing-text">{{ uiLabels["waiting"] || "Waiting..." }}</h3>

      <button class="action-btn ready-btn" :class="{ 'not-ready-btn': isReady }" v-on:click="toggleReady">
        {{ isReady ? (uiLabels.notReady || "NOT READY") : (uiLabels.ready || "READY") }}
      </button>

      <h3>{{ uiLabels.participants || "Participants" }}:</h3>

      <div class="participants-grid">
        <div v-for="(participant, index) in displayParticipants" :key="index" class="participant-card" :class="{
          'is-me': participant.name === userName,
          'ready': participant.isReady
        }">
          {{ participant.name }}
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import io from 'socket.io-client';
const socket = io(sessionStorage.getItem("dataServer"));

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
      participants: []
    }
  },
  computed: {
    displayParticipants() {
      const list = [...this.participants];
      const me = list.find(p => p.name === this.userName);
      // Lägg till isReady: this.isReady här så det syns direkt för dig själv
      if (this.joined && !me && this.userName) {
        list.push({ name: this.userName, isReady: this.isReady });
      }
      return list;
    }
  },
  created: function () {
    this.pollId = this.$route.params.id;
    socket.on("uiLabels", labels => this.uiLabels = labels);
    socket.on("participantsUpdate", p => this.participants = p);
    socket.on("startPoll", () => this.$router.push("/poll/" + this.pollId));
    socket.emit("joinPoll", this.pollId);
    socket.emit("getUILabels", this.lang);
  },
  methods: {
    participateInPoll: function () {
      if (this.userName.length > 0) {
        socket.emit("participateInPoll", { pollId: this.pollId, name: this.userName })
        this.joined = true;
      }
    },
    toggleReady: function () {
      this.isReady = !this.isReady;
      // Skicka statusuppdatering till servern
      socket.emit("playerReady", {
        pollId: this.pollId,
        name: this.userName,
        isReady: this.isReady
      });
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
  margin-bottom: 1.5rem;
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
  align-items: center;
  gap: 1.5rem;
  background-color: rgba(10, 48, 76, 0.85);
  padding: 3rem;
  border-radius: 20px;
  border: 2px solid gold;
  box-shadow: 0 0 20px rgba(255, 215, 0, 0.3);
  margin-top: 2rem;
}

.input-wrapper {
  border-bottom: 2px solid gold;
  width: 100%;
}

input {
  background: transparent;
  border: none;
  color: gold;
  font-size: 1.5rem;
  padding: 10px;
  text-align: center;
  outline: none;
  font-weight: bold;
  width: 250px;
}

input::placeholder {
  color: rgba(255, 215, 0, 0.5);
}

.action-btn {
  background: linear-gradient(145deg, #311b92, #512da8);
  color: gold;
  font-size: 1.2rem;
  font-weight: bold;
  padding: 12px 40px;
  border: 2px solid gold;
  border-radius: 30px;
  cursor: pointer;
  transition: transform 0.2s, box-shadow 0.2s, background 0.3s;
  text-transform: uppercase;
  letter-spacing: 1px;
}

.action-btn:hover:not(:disabled) {
  transform: scale(1.05);
  box-shadow: 0 0 15px gold;
}

.action-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
  border-color: grey;
  color: grey;
}

.waiting-container {
  width: 100%;
  max-width: 800px;
  text-align: center;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.pulsing-text {
  animation: pulse 2s infinite;
  margin-bottom: 1rem;
  color: gold;
  font-style: italic;
}

.ready-btn {
  margin-bottom: 2rem;
  min-width: 180px;
  box-shadow: 0 0 15px rgba(255, 215, 0, 0.3);
}

.not-ready-btn {
  background: linear-gradient(145deg, #c62828, #d32f2f) !important;
  border-color: #ff8a80;
  color: white;
  box-shadow: 0 0 15px rgba(255, 0, 0, 0.4) !important;
}

.not-ready-btn:hover {
  background: linear-gradient(145deg, #d32f2f, #e53935) !important;
  box-shadow: 0 0 20px rgba(255, 0, 0, 0.6) !important;
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

/* Hitta detta block och ersätt det */
.participant-card {
  /* ÄNDRAT: Från blå gradient till grå */
  background: grey;
  /* ÄNDRAT: Bytt kantfärg från ljusblå till en ljusgrå för att matcha bättre */
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
  /* Lade till en liten guldeffekt för att markera dig */
}

.participant-card.ready {
  background: linear-gradient(145deg, #2e7d32, #43a047) !important;
  /* Grön */
  border-color: #2e7d32;
}


@keyframes popIn {
  0% {
    transform: scale(0);
  }

  80% {
    transform: scale(1.1);
  }

  100% {
    transform: scale(1);
  }
}
</style>