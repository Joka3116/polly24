<template>
<div class="lang-switch-container" @click="toggleLang">
  <div class="lang-switch-circle" :class="{ 'is-sv': currentLang === 'SV' }"></div>
  <div class="lang-switch-text-container">
    <div class="lang-switch-en-color" :class="{ 'active': currentLang === 'EN' }">EN</div>
    <div class="lang-switch-sv-color" :class="{ 'active': currentLang === 'SV' }">SV</div>
  </div>
</div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue';

const emit = defineEmits(['switch-language']);
const currentLang = ref((localStorage.getItem("lang") || "en").toUpperCase());

const updateLangState = () => {
    currentLang.value = (localStorage.getItem("lang") || "en").toUpperCase();
};

const toggleLang = () => {
    const newLang = currentLang.value === 'EN' ? 'sv' : 'en';
    localStorage.setItem("lang", newLang);
    window.dispatchEvent(new Event('lang-change'));
    emit('switch-language', newLang);
    updateLangState();
};

onMounted(() => {
    window.addEventListener('lang-change', updateLangState);
});

onUnmounted(() => {
    window.removeEventListener('lang-change', updateLangState);
});
</script>

<style scoped>

.lang-switch-container {
  width: 10.5rem;
  height: 5.25rem;
  position: relative;
  cursor: pointer;
  border-radius: 3em;
  border: 2px solid var(--background-color);
  overflow: hidden; 
}

.lang-switch-circle {
  position: absolute;
  top: 0;
  left: 0;
  width: 50%;
  height: 100%;
  border-radius: 50%;
  background-color: var(--background-color);
  transition: transform 0.3s ease-in-out;
  z-index: 1;
}

.lang-switch-circle.is-sv {
   transform: translateX(100%);
}

.lang-switch-text-container {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  display: grid;
  grid-template-columns: 1fr 1fr;
  place-items: center;
  font-family: bebas-kai, sans-serif;
  font-size: 2.5rem;
  line-height: 1;
  z-index: 2; 
  pointer-events: none;
}

.lang-switch-en-color,
.lang-switch-sv-color {
  color: var(--background-color);
  transition: color 0.3s ease-in-out;
}

.lang-switch-en-color.active,
.lang-switch-sv-color.active {
  color: var(--background-alt-color);
}

/* =========================================
   Mobile Breakpoint
   ========================================= */
@media (max-width: 768px) {
    .lang-switch-container {
        width: 6rem !important;
        height: 3rem !important;
    }
    .lang-switch-circle {
        width: 50%;
        height: 100%;
    }
    .lang-switch-text-container {
        font-size: 1.8rem;
    }
}
</style>
