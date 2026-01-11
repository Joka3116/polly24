<template>
  <div class="question-wrapper">
    <h1 class="question-text" v-if="isHost || showResults">
      {{ question.text }}
    </h1>

    <div v-if="!isHost || showResults" class="player-view">
      <div class="answers-grid">
        <button 
          v-for="(answer, index) in question.answers" 
          :key="index"
          class="answer-btn"
          :disabled="timeExpired || showResults || isHost" 
          :class="{ 
            'selected': selectedAnswer === answer,
            'correct': showResults && answer.id === correctAnswerId,
            'wrong': showResults && selectedAnswer === answer && answer.id !== correctAnswerId,
            'time-out': timeExpired && !selectedAnswer && !showResults
          }" 
          @click="clicked(answer)"
        >
          {{ answer.text }}
        </button>
      </div>
    </div>

    </div>
</template>
<script>
export default {
  name: 'QuestionComponent',
  props: {
    question: Object,
    isHost: Boolean,
    showResults: Boolean,
    timeExpired: Boolean,
    correctAnswerId: [Number, String]
  },
  emits: ["answer"],
  data: function () {
    return {
      selectedAnswer: null
    }
  },
  watch: {
    question: function () {
      this.selectedAnswer = null;
    }
  },
  methods: {
    clicked: function (answer) {
      if (this.selectedAnswer || this.isHost || this.showResults) return;

      this.selectedAnswer = answer;
      this.$emit("answer", answer);
    }
  }
}

</script>

<style scoped>
.question-wrapper {
  display: flex;
  flex-direction: column;
  align-items: center;
  width: 100%;
}

.question-text {
  color: white;
  font-size: 2rem;
  text-align: center;
  margin-bottom: 1.5rem;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.8);
}

.answers-grid {
  display: grid;
  /* Tvingar fram 2 kolumner oavsett skärmstorlek */
  grid-template-columns: 1fr 1fr; 
  /* Minskat gap för att få plats på mobilen */
  gap: clamp(10px, 2vw, 20px); 
  width: 100%;
  max-width: 1000px;
  padding: 15px;
  box-sizing: border-box;
}

.answer-btn {
  background: linear-gradient(145deg, #311b92, #512da8);
  color: gold;
  border: clamp(2px, 0.5vw, 4px) solid gold; 
  border-radius: 30px; 
  
  /* Flexibel textstorlek för att undvika radbrytningar på små skärmar */
  font-size: clamp(0.9rem, 2.5vw, 1.6rem);
  
  font-weight: bold;
  text-transform: uppercase;
  text-shadow: 1px 1px 0 rgba(0,0,0,0.5);
  
  /* Säkrar att knapparna är stora men inte för höga på mobil */
  padding: clamp(10px, 2vh, 25px);
  min-height: clamp(80px, 15vh, 120px); 
  
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  text-align: center;
  transition: all 0.2s ease;
}

.answer-btn:hover {
  transform: scale(1.03);
  box-shadow: 0 0 20px gold;
}

.answer-btn:active {
  transform: scale(0.98);
}

@media (max-width: 600px) {
  .answers-grid {
    padding: 10px;
    gap: 12px;
  }
  
  .answer-btn {
    border-radius: 20px;
    /* Gör texten lite smalare på mobil om namnen är långa */
    letter-spacing: 0px; 
  }
}
.answer-btn.selected {
  color: gold;
  border-color: gold;
  transform: scale(1.05);
  box-shadow: 0 0 20px white;
}

.answers-grid:has(.selected) .answer-btn:not(.selected) {
  opacity: 0.4;
  cursor: default;
}

.answer-btn.correct {
  background: linear-gradient(145deg, #2e7d32, #43a047) !important;
  border-color: #a5d6a7;
}

.answer-btn.wrong {
  color: gold;
  border-color: gold;
  transform: scale(1.05);
  box-shadow: 0 0 20px white;
}

.answer-btn:disabled {
  cursor: not-allowed;
  filter: grayscale(0.8);
  opacity: 0.6;
}

.answer-btn.time-out {
  border-color: #ff3e3e;
<<<<<<< Updated upstream
  box-shadow: none;
=======
  box-shadow: none; 
>>>>>>> Stashed changes
}

.answer-btn:hover:not(:disabled) {
  transform: scale(1.02);
  box-shadow: 0 0 25px gold;
  background: linear-gradient(145deg, #4527a0, #673ab7);
}
</style>