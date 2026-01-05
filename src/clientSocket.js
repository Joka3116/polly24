import io from "socket.io-client";

// Force the server IP to match original StartView behavior
sessionStorage.setItem("dataServer", "localhost:3000");
sessionStorage.setItem("localServer", "localhost:3000");

const socket = io(sessionStorage.getItem("dataServer"));

export default socket;
