<template>
  <div class="result-view content-container">

    <h1>{{ uiLabels.result || "RESULTAT" }}</h1>

    <p v-if="phase === 'loading'">
      {{ uiLabels.loading || "Laddar resultat..." }}
    </p>

    <div v-else-if="phase === 'podium'" class="podium panel-card">

      <div v-if="revealStep >= 3 && results[0]" class="podium-slot first">
        <span class="place">1</span>
        <span class="name">{{ results[0].name }}</span>
        <span class="points">{{ results[0].points }} pts</span>
      </div>

      <div v-if="revealStep >= 2 && results[1]" class="podium-slot second">
        <span class="place">2</span>
        <span class="name">{{ results[1].name }}</span>
        <span class="points">{{ results[1].points }} pts</span>
      </div>

      <div v-if="revealStep >= 1 && results[2]" class="podium-slot third">
        <span class="place">3</span>
        <span class="name">{{ results[2].name }}</span>
        <span class="points">{{ results[2].points }} pts</span>
      </div>

    </div>

    <div v-else class="leaderboard panel-card">
      <div v-for="(player, index) in results" :key="player.name" class="player-row" :class="{ winner: index === 0 }">
        <span class="rank">#{{ index + 1 }}</span>
        <span class="name">{{ player.name }}</span>
        <span class="points">{{ player.points }} pts</span>
      </div>
    </div>

    <button class="btn-main" @click="goHome()">
      {{ uiLabels.startingPage || "Gå till startsidan" }}
    </button>

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
        {{ uiLabels.createGame || "CREATE!" }}
      </router-link>

      <LangSwitch @switch-language="switchLanguage" />
    </ResponsiveNav>

  </div>
</template>

<script>
import socket from "@/socket.js";
import ResponsiveNav from "@/components/ResponsiveNav.vue";
import LangSwitch from "@/components/LangSwitch.vue";
import confetti from "canvas-confetti";

export default {
  name: "ResultView",

  components: {
    ResponsiveNav,
    LangSwitch
  },

  data: function () {
    return {
      pollId: null,
      results: [],
      phase: "loading", // "loading" | "podium" | "leaderboard"
      revealStep: 0,
      uiLabels: {},
      lang: localStorage.getItem("lang") || "en",
      confettisound: null
    };
  },

  created: function () {
    this.confettiSound = new Audio("/sounds/confetti.mp3");
    this.confettiSound.volume = 0.5;

    socket.on("uiLabels", (labels) => (this.uiLabels = labels));
    socket.emit("getUILabels", this.lang);

    console.log("ResultView created");
    this.pollId = this.$route.params.id;
    this.phase = "loading";

    socket.emit("getFinalResults", this.pollId);

    socket.on("finalResults", results => {
      console.log(results);

      this.results = [...results].sort((a, b) => b.points - a.points);


      if (!this.results.length) {
        this.phase = "leaderboard";
        console.log("No results to show.");
        return;
      }

      console.log("Final results received");

      this.phase = "podium";
      setTimeout(() => (this.revealStep = 1), 1500);

      setTimeout(() => (this.revealStep = 2), 3000);

      setTimeout(() => {
        this.revealStep = 3;

        this.confettiSound.play().catch((e) => {
          console.warn("Could not play confetti sound:", e);
        });

        confetti({
          particleCount: 200,
          spread: 90,
          origin: { y: 0.6 }
        });
      }, 6000);

      setTimeout(() => {
        this.phase = "leaderboard";
      }, 11000);
    });

  },

  beforeUnmount() {
    socket.off("finalResults");
  },

  methods: {
    goHome() {
      localStorage.removeItem("isHost");
      localStorage.removeItem("userName");
      this.$router.push("/");
    },

    switchLanguage(lang) {
      if (lang) {
        this.lang = lang;
      } else {
        this.lang = this.lang === "en" ? "sv" : "en";
      }

      localStorage.setItem("lang", this.lang);
      socket.emit("getUILabels", this.lang);
    },

  }
};
</script>

<style scoped>
.hidden {
  opacity: 0;
  pointer-events: none;
  position: absolute;
  transform: scale(0.95);
}

.result-view {
  min-height: 100vh;
  color: var(--foreground-color);
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 3rem 1rem;
}

.result-view h1 {
  color: var(--headline-color);
  font-size: 3rem;
  letter-spacing: 4px;
  margin-bottom: 2rem;
  text-shadow: 0 0 15px rgba(255, 215, 0, 0.6);
}

.leaderboard {
  width: 100%;
  max-width: 600px;
  margin-bottom: 3rem;
}

.player-row {
  display: grid;
  grid-template-columns: 60px 1fr 120px;
  align-items: center;
  padding: 1rem 1.5rem;
  margin-bottom: 0.6rem;
  background: rgba(0, 0, 0, 0.35);
  border-radius: 50px;
  font-size: 1.2rem;
  border: 2px solid transparent;
}

.player-row.winner {
  background: linear-gradient(145deg, gold, orange);
  color: var(--foreground-alt-color);
  font-weight: bold;
  border-color: white;
  box-shadow: 0 0 20px rgba(255, 215, 0, 0.8);
}

.rank {
  font-weight: bold;
  text-align: center;
}

.points {
  text-align: right;
}

.podium {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  text-align: center;
  margin-bottom: 3rem;
  min-width: 180px;
  min-height: 150px;
}

.podium-slot {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.6rem;

  opacity: 0;
  transform: translateY(20px) scale(0.95);
  animation: reveal 0.6s ease-out forwards;

  padding: 1.5rem;
  border-radius: 30px;
}

.podium-slot.first {
  background: linear-gradient(145deg, gold, orange);
  color: black;
  font-size: 2rem;
  box-shadow: 0 0 40px gold;
}

.podium-slot.second {
  background: silver;
  color: black;
}

.podium-slot.third {
  background: #cd7f32;
  color: black;
}

.place {
  font-size: 3rem;
  font-weight: bold;
}

.podium-slot .points {
  font-size: 1.1rem;
  opacity: 0.85;
}

@keyframes reveal {
  to {
    opacity: 1;
    transform: translateY(0) scale(1);
  }
}

@media (max-width: 600px) {
  .result-view h1 {
    font-size: 2.2rem;
    margin-bottom: 1.5rem;
  }

  .podium {
    gap: 0.8rem;
    padding: 1.5rem;
  }

  .podium-slot {
    padding: 1rem;
    border-radius: 20px;
  }

  .podium-slot.first {
    font-size: 1.6rem;
  }

  .place {
    font-size: 2.2rem;
  }

  .leaderboard {
    max-width: 80vw;
    width: 80%;
    margin-left: center;
    margin-right: center;
  }

  .player-row {
    grid-template-columns: 40px 1fr 80px;
    font-size: 1rem;
    padding: 0.8rem 1rem;
  }

  .btn-main {
    font-size: 1.4rem;
    padding: 14px 40px;
    margin-top: 1.5rem;
  }
}

@media (min-width: 900px) {
  .podium {
    flex-direction: row;
    align-items: flex-end;
  }

  .podium-slot.first {
    transform: scale(1.1);
  }
}

.result-footer {
  margin-top: auto;
  padding: 2rem 0 1rem;
  font-size: 0.9rem;
  opacity: 0.6;
}
</style>
