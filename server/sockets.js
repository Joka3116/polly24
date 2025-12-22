
let timers = {};

function sockets(io, socket, data) {

  socket.on('getUILabels', function (lang) {
    socket.emit('uiLabels', data.getUILabels(lang));
  });

  socket.on('createPoll', function (d) {
    data.createPoll(d.pollId, d.lang)
    socket.emit('pollData', data.getPoll(d.pollId));
  });

  socket.on('joinPoll', function (pollId) {
    socket.join(pollId);
    socket.emit('questionUpdate', null)
    socket.emit('submittedAnswersUpdate', data.getSubmittedAnswers(pollId));
  });

socket.on('participateInPoll', function (d) {

    if (data.nameAvailable(d.pollId, d.name)) {
      data.participateInPoll(d.pollId, d.name);

      io.to(d.pollId).emit('participantsUpdate', data.getParticipants(d.pollId));

      socket.emit('joinSuccess'); 
    } else {
      socket.emit('nameTaken', {
        title: "IDENTITETSSTÖLD",
        message: "En operatör med det namnet är redan inloggad. Billionaire-motorn tillåter inga digitala kloner."
      });
    }
  });

  socket.on('playerReady', function (d) {
    data.setPlayerReady(d.pollId, d.name, d.isReady);
    io.to(d.pollId).emit('participantsUpdate', data.getParticipants(d.pollId));
  });

socket.on('startPoll', async function (d) {
  let poll = data.getPoll(d.pollId);

  // 1. Spara BARA inställningar om de skickas med (från CreateView)
  if (d.difficulty && d.nrOfQuestions) {
    data.saveSettings(d.pollId, {
      nrOfQuestions: d.nrOfQuestions,
      difficulty: d.difficulty
    });
  }

  // 2. Hämta nu den slutgiltiga svårighetsgraden från sparad data 
  // (eller fallbacks om allt annat skiter sig)
  const finalDifficulty = poll.settings?.difficulty || d.difficulty || 'medium';
  
  console.log("--- STARTAR SPELET ---");
  console.log("Vald svårighetsgrad som används:", finalDifficulty);

  io.to(d.pollId).emit('startPoll', d.pollId);
  
  let question = await data.getRandomQuestion(d.language || "en");
  data.addQuestion(d.pollId, question);
  
  if (poll) {
    poll.answers = [];
  }

  io.to(d.pollId).emit('questionUpdate', question);
  io.to(d.pollId).emit('submittedAnswersUpdate', {});

  // 3. Starta timern med den bekräftade svårighetsgraden
  startTimer(d.pollId, finalDifficulty);
});


  socket.on('submitAnswer', function (d) {
    data.submitAnswer(d.pollId, d.answer);
    io.to(d.pollId).emit('submittedAnswersUpdate', data.getSubmittedAnswers(d.pollId));
  });
  socket.on('showResults', function (d) {
  io.to(d.pollId).emit('showResults');
});

socket.on('checkPollExists', function (pollId) {
    const exists = data.pollExists(pollId);
    socket.emit('pollExistsResponse', exists);
  });

function startTimer(pollId, difficulty) {
  // 1. Rensa ALLTID den specifika timern om den redan körs för detta ID
  if (timers[pollId]) {
    clearInterval(timers[pollId]);
    console.log("Stoppade gammal timer för:", pollId);
  }

  const times = { easy: 60, medium: 45, hard: 30 };
  const diffKey = difficulty ? difficulty.toLowerCase() : 'medium';
  let timeLeft = times[diffKey] || 45;

  io.to(pollId).emit('timerUpdate', timeLeft);

  timers[pollId] = setInterval(() => {
    timeLeft -= 1;
    io.to(pollId).emit('timerUpdate', timeLeft);

    if (timeLeft <= 0) {
      clearInterval(timers[pollId]);
      delete timers[pollId]; 
      io.to(pollId).emit('showResults');
    }
  }, 1000);
}

  socket.on('runQuestion', async function (d) {
    let poll = data.getPoll(d.pollId);
    if (!poll || !poll.settings) return;

    if (poll.questions.length >= poll.settings.nrOfQuestions) {
      io.to(d.pollId).emit('gameOver', { reason: 'Limit reached' });
      return;
    }

    let question = await data.getRandomQuestion(poll.lang || "sv");
    data.addQuestion(d.pollId, question);
    
    if (poll.answers) poll.answers = [];

    io.to(d.pollId).emit('questionUpdate', question);
    io.to(d.pollId).emit('submittedAnswersUpdate', {});
    io.to(d.pollId).emit('hideResults');


    startTimer(d.pollId, poll.settings.difficulty);
  });
  

  socket.on('showResults', function (d) {
    if (timers[d.pollId]) clearInterval(timers[d.pollId]);
    io.to(d.pollId).emit('showResults');
  });
}

export { sockets };