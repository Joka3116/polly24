<template>
  <header>
    <div v-bind:class="['hamburger', {'close': !hideNav}]" 
         v-on:click="toggleNav">
    </div>
    <div class="logo">
      <img src="/img/logo.png">
      Who wants to be a billionaire 
    </div>
  </header>
  
  <div class="page-wrapper">
  <div class="center-logo">
  <img src="/img/logo.png" alt="Logo">
</div>

  <ResponsiveNav v-bind:hideNav="hideNav">
    <button v-on:click="switchLanguage">
      {{ uiLabels.changeLanguage }}
    </button>
    <router-link to="/create/">
      {{ uiLabels.createPoll }}
    </router-link>
    <a href="">
      {{ uiLabels.about }}
    </a>
    <a href="">FAQ</a>
  </ResponsiveNav>
  <h1>{{ uiLabels["sales-pitch"] }}</h1>
  <h2>{{ uiLabels.subHeading }}</h2>
  <label>
    Write poll id: 
    <input type="text" v-model="newPollId">
  </label>
  <router-link v-bind:to="'/lobby/' + newPollId">
    {{ uiLabels.participatePoll }}
  </router-link>
  
  <div class="play-container">
  <button class="play-btn" @click="$router.push('/create')">
    PLAY
  </button>
  </div>

  </div>
</template>

<script>
import ResponsiveNav from '@/components/ResponsiveNav.vue';
import io from 'socket.io-client';
const socket = io("localhost:3000");

export default {
  name: 'StartView',
  components: {
    ResponsiveNav
  },
  data: function () {
    return {
      uiLabels: {},
      newPollId: "",
      lang: localStorage.getItem( "lang") || "en",
      hideNav: true
    }
  },
  created: function () {
    socket.on( "uiLabels", labels => this.uiLabels = labels );
    socket.emit( "getUILabels", this.lang );
  },
  methods: {
    switchLanguage: function() {
      if (this.lang === "en") {
        this.lang = "sv"
      }
      else {
        this.lang = "en"
      }
      localStorage.setItem( "lang", this.lang );
      socket.emit( "getUILabels", this.lang );
    },
    toggleNav: function () {
      this.hideNav = ! this.hideNav;
    }
  }
}
</script>
<style scoped>


  header {
    background-color: rgba(60, 12, 116, 1)   ;
    width: 100%;
    display: grid;
    grid-template-columns: 2em auto;
  }
  .page-wrapper {
  background-color: purple;
  background-size: 100% auto; /* Full bredd, behåll proportioner */
  background-repeat: no-repeat;
  background-position: center top;
  background-attachment: fixed;
  min-height: 100vh;
  margin: 0;
  padding: 0;
}
  .logo {
    text-transform: uppercase;
    letter-spacing: 0.25em;
    font-size: 2.5rem;
    color: white;
    padding-top:0.2em;
  }
  .logo img {
    height:5rem;
    vertical-align: bottom;
    margin-right: 0.5rem; 
  }
  .hamburger {
    color:white;
    width:1em;
    display: flex;
    align-items: center;
    justify-content: left;
    padding:0.5rem;
    top:0;
    left:0;
    height: 2rem;
    cursor: pointer;
    font-size: 1.5rem;
  }
  .play-container {
  margin-top: 2rem;
  display: flex;
  justify-content: center;
}

.play-btn {
  background: radial-gradient(circle, #512da8, #311b92);
  color: gold;
  padding: 12px 40px;
  font-size: 1.8rem;
  font-weight: bold;
  border: 3px solid gold;
  border-radius: 30px;
  letter-spacing: 3px;
  cursor: pointer;
  box-shadow: 0 0 15px gold;
  transition: 0.2s ease;
}

.play-btn:hover {
  transform: scale(1.1);
  box-shadow: 0 0 25px gold;
}


@media screen and (max-width:50em) {
  .logo {
    font-size: 5vw;
    display: flex;
    align-items: center;
    justify-content: center;
  }
  .hamburger::before {
    content: "☰";
  }
  .close::before {
    content: "✕";
  }
  .hide {
    left:-12em;
  }
  
}

.center-logo {
  margin-top: 3rem;
  display: flex;
  justify-content: center;
  width: 100%;
}

.center-logo img {
  width: 300px;   /* ändra storlek här */
  height: auto;
}



</style>

