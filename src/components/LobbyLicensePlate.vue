<template>
  <div class="license-plate">
    <div class="plate-screw top-left">+</div>
    <div class="plate-screw top-right">+</div>
    <span class="plate-header">LOBBY ID</span>
    <span class="plate-number">{{ pollId || "----" }}</span>
    <div class="plate-screw bottom-left">+</div>
    <div class="plate-screw bottom-right">+</div>
  </div>
</template>

<script setup>
defineProps({
  pollId: {
    type: [String, Number],
    required: false,
    default: ""
  }
})
</script>

<style scoped>
.license-plate {
    position: relative;
    z-index: 10;
    
    background: 
        radial-gradient(circle at 15% 25%, rgba(0,0,0,0.1) 0%, transparent 25%),
        radial-gradient(circle at 85% 75%, rgba(0,0,0,0.15) 0%, transparent 30%),
        linear-gradient(160deg, #ffc107 0%, #ffb300 60%, #e0a800 100%);
    border: 0.4rem solid #333;
    border-radius: 0.6rem;
    padding: 0.5rem 1rem;
    box-shadow: 
        0 4px 6px rgba(0,0,0,0.5), 
        inset 0 0 15px rgba(50, 40, 0, 0.4);
    
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    
    min-width: 12rem;
    transform: rotate(-3deg);
    margin: 0.5rem auto 3rem auto; /* Centered with margins */
}

.plate-header {
    font-size: 0.8rem;
    letter-spacing: 2px;
    margin-bottom: 0;
    text-transform: uppercase;
    font-weight: bold;
    color: #333;
    font-family: 'Helvetica', sans-serif;
}

.plate-number {
    font-size: 3rem;
    letter-spacing: 4px;
    font-weight: 900;
    line-height: 1;
    color: #333;
    font-family: 'Courier New', monospace;
    text-shadow: 1px 1px 0 rgba(255,255,255,0.5);
}

.plate-screw {
    position: absolute;
    color: #888;
    font-size: 1.2rem;
    font-family: sans-serif;
    line-height: 1;
    text-shadow: 1px 1px 0 white;
}
.top-left { top: 0.2rem; left: 0.4rem; }
.top-right { top: 0.2rem; right: 0.4rem; }
.bottom-left { bottom: 0.2rem; left: 0.4rem; }
.bottom-right { bottom: 0.2rem; right: 0.4rem; }

@media (max-width: 768px) {
    .license-plate {
        margin: 0.5rem auto 2rem auto;
    }
}
</style>
