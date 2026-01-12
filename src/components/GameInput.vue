<template>
    <div class="game-input-area" :class="{ shake: isShaking }" ref="containerRef">
        <input
            ref="gameInputRef"
            type="text"
            class="input-main"
            v-model="gameId"
            :placeholder="uiLabels['gameID'] || 'Game ID'"
            v-on:keyup.enter="joinGame"
        />

        <button class="btn-main" @click="joinGame">
            {{ uiLabels.join || "JOIN!" }}
        </button>

        <button
            class="back-btn"
            @click="emitCancel"
        >
            <i class="bi bi-x-lg"></i>
        </button>
    </div>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount } from 'vue';
import { useRouter } from 'vue-router';
import socket from "@/socket.js";

const props = defineProps({
    uiLabels: {
        type: Object,
        required: true,
    },
});

const emit = defineEmits(["cancel"]);
const router = useRouter();

const gameId = ref("");
const isShaking = ref(false);
const gameInputRef = ref(null);
const containerRef = ref(null);

const triggerShake = () => {
    isShaking.value = true;
    gameInputRef.value?.focus();
    setTimeout(() => {
        isShaking.value = false;
    }, 500);
};

function joinGame() {
    if (!gameId.value) {
        triggerShake();
        return;
    }

    socket.emit("checkPollExists", gameId.value);

    socket.once("pollExistsResponse", (exists) => {
        if (exists) {
            router.push("/lobby/" + gameId.value);
        } else {
            triggerShake();
        }
    });
}

function emitCancel() {
    emit("cancel");
}

function handleClickOutside(event) {
    if (containerRef.value && !containerRef.value.contains(event.target)) {
        emitCancel();
    }
}

onMounted(() => {
    // Add a slight delay or use setTimeout to avoid catching the click that opened this component
    setTimeout(() => {
        window.addEventListener('click', handleClickOutside);
    }, 100);
});

onBeforeUnmount(() => {
    window.removeEventListener('click', handleClickOutside);
});
</script>

<style scoped>
.game-input-area {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 1.5rem;
    width: 100%;
}

.back-btn {
    background: var(--button-background-color);
    border: 2px solid var(--button-color);
    color: var(--button-color);
    font-size: 1.5rem;
    font-weight: bold;
    width: 4rem;
    height: 4rem;
    border-radius: 50%;
    cursor: pointer;
    box-shadow: 0 0 12px var(--button-color);
    transition: 0.2s ease;
}

.back-btn:hover {
    transform: scale(1.05);
    box-shadow: 0 0 25px rgba(255, 215, 0, 0.6);
    filter: brightness(1.1);
}
.back-btn i {
    transition: font-size 0.2s ease;
}

.back-btn:hover i {
    font-size: 2rem;
}

@keyframes shake {
    0%, 100% { transform: translateX(0); }
    10%, 30%, 50%, 70%, 90% { transform: translateX(-3px); }
    20%, 40%, 60%, 80% { transform: translateX(3px); }
}

.shake {
    animation: shake 0.5s cubic-bezier(.36,.07,.19,.97) both;
}

</style>
