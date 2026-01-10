<template>
    <div class="game-input-area">
        <input
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

        <div
            v-if="showErrorModal"
            class="modal-overlay"
            @click="showErrorModal = false"
        >
            <div class="panel-card" @click.stop>
                <h2>{{ uiLabels.errorTitle || "USER ERROR" }}</h2>

                <p>
                    {{
                        uiLabels.serverMissing ||
                        "Impressively incorrect. This node is deader than the code it's running on..."
                    }}
                </p>

                <button class="btn-main" @click="showErrorModal = false">
                    {{ uiLabels.okButton || "UNDERSTOOD" }}
                </button>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import socket from "@/clientSocket.js";

const props = defineProps({
    uiLabels: {
        type: Object,
        required: true,
    },
});

const emit = defineEmits(["cancel"]);
const router = useRouter();

const gameId = ref("");
const showErrorModal = ref(false);

function joinGame() {
    if (!gameId.value) return;

    socket.emit("checkPollExists", gameId.value);

    socket.once("pollExistsResponse", (exists) => {
        if (exists) {
            router.push("/lobby/" + gameId.value);
        } else {
            showErrorModal.value = true;
        }
    });
}

function emitCancel() {
    emit("cancel");
}
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
</style>
