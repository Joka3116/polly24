<template>
  <div class="question-wrapper">
    <h1 class="question-text">
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
            'correct': showResults && answer.is_correct,
            'wrong': showResults && selectedAnswer === answer && !answer.is_correct,
            'time-out': timeExpired && !selectedAnswer && !showResults
          }" 
          @click="clicked(answer)"
        >
          {{ answer.text }}
        </button>
      </div>
    </div>

    <div v-else class="host-waiting-info">
      <p class="pulsing-text">Operatörerna väljer sina svar...</p>
    </div>
  </div>
</template>
<script>
export default {
  name: 'GameQuestion',
  props: {
    question: Object,
    isHost: Boolean,
    showResults: Boolean,
    timeExpired: Boolean
  },
  emits: ["answer"],
  data: function () {
    return {
      selectedAnswer: null
    }
  },
  watch: {
    question: function() {
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
  text-shadow: 0 2px 4px rgba(0,0,0,0.8);
}

.answers-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
  width: 100%;
  max-width: 800px;
  padding: 0 10px;
}

.answer-btn {
  background: linear-gradient(145deg, #311b92, #512da8);
  color: gold;
  border: 3px solid gold;
  border-radius: 30px;
  font-size: 1.2rem;
  font-weight: bold;
  text-transform: uppercase;
  text-shadow: 1px 1px 0 rgba(0,0,0,0.5);
  letter-spacing: 1px;
  padding: 20px;
  min-height: 100px;
  cursor: pointer;
  box-shadow: 0 0 10px rgba(255, 215, 0, 0.3);
  transition: transform 0.2s, box-shadow 0.2s;
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
    grid-template-columns: 1fr;
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
</style>