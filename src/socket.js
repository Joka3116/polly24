import io from "socket.io-client";

// Använder hostname istället för "localhost" så att det fungerar på alla enheter
const serverAddress = `${window.location.hostname}:3000`;

sessionStorage.setItem("dataServer", serverAddress);
sessionStorage.setItem("localServer", serverAddress);

const socket = io(serverAddress);

export default socket;