
let timers = {};

function sockets(io, socket, data) {
  socket.on('saveSettings', function (d) {
    data.saveSettings(d.pollId, {
      nrOfQuestions: d.nrOfQuestions,
      difficulty: d.difficulty
    });
  });

  socket.on('initiateGameNavigation', function (d) {
    io.to(d.pollId).emit('navToPoll', d.pollId);
  });


  socket.on('startPoll', async function (d) {
    let poll = data.getPoll(d.pollId);
    if (poll.questions && poll.questions.length > 0) return;

    poll.currentQuestion = 0;

    console.log("--- BILLIONAIRE ENGINE INITIATED ---");
    let question = await data.getRandomQuestion(d.language || "en");


    data.addQuestion(d.pollId, question);
    const sanitizedQuestion = {
      id: question.id,
      text: question.text,
      answers: question.answers.map(a => ({ id: a.id, text: a.text })),
      currentNumber: poll.currentQuestion + 1, // +1 eftersom currentQuestion börjar på 0
      totalQuestions: poll.settings.nrOfQuestions
    };


    io.to(d.pollId).emit('questionUpdate', sanitizedQuestion);


    io.to(d.pollId).emit('submittedAnswersUpdate', {});
    startTimer(d.pollId, poll.settings?.difficulty || 'medium');
  });
  socket.on('getUILabels', function (lang) {
    socket.emit('uiLabels', data.getUILabels(lang));
  });

  socket.on('createPoll', function (d) {
    data.createPoll(d.pollId, d.lang)
    socket.emit('pollData', data.getPoll(d.pollId));
  });

  socket.on('joinPoll', function (pollId) {
    socket.join(pollId);
    let poll = data.getPoll(pollId);

    // Om det finns frågor, skicka den aktuella
    if (poll.questions && poll.questions.length > 0) {
      socket.emit('questionUpdate', poll.questions[poll.currentQuestion]);
    }
    // Om inga frågor finns, skicka INTE null. 
    // Frontenden har redan ett bra standard-objekt i data()

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

  socket.on('submitAnswer', function (d) {

    data.submitAnswer(d.pollId, d.userName, d.answerId, d.timeLeft);

    const answeredCount = data.getAnsweredCount(d.pollId);
    const totalPlayers = data.getParticipants(d.pollId).filter(p => p.name !== 'Host').length;

    io.to(d.pollId).emit('answersUpdate', { answered: answeredCount, total: totalPlayers });

    if (answeredCount >= totalPlayers && totalPlayers > 0) {
      if (timers[d.pollId]) {
        clearInterval(timers[d.pollId]);
        delete timers[d.pollId];
      }

      endOfQuestion(io, data, d.pollId);
    }

  });

  socket.on('forceEndQuestion', d => {
    if (timers[d.pollId]) {
      clearInterval(timers[d.pollId]);
      delete timers[d.pollId];
    }

    endOfQuestion(io, data, d.pollId);
  });

  socket.on('checkPollExists', function (pollId) {
    const exists = data.pollExists(pollId);
    socket.emit('pollExistsResponse', exists);
  });

  socket.on("getFinalResults", pollId => {
    const poll = data.getPoll(pollId);

    if (!poll) {
      socket.emit("finalResults", []);
      return;
    }

    const participants = Array.isArray(poll.participants)
      ? poll.participants
      : [];

    const leaderboard = participants
      .filter(p => p.name !== "Host")
      .map(p => ({
        name: p.name,
        points: p.points || 0
      }))
      .sort((a, b) => b.points - a.points);

    console.log("FINAL RESULTS SENT:", leaderboard);

    socket.emit("finalResults", leaderboard);
  });

  socket.on('patchCurrentQuestion', async function (d) {
    let poll = data.getPoll(d.pollId);

    let currentQ = poll.questions[poll.currentQuestion];

    if (currentQ && currentQ.sharedId) {
      let translated = await data.getQuestionBySharedId(currentQ.sharedId, d.lang);

      if (translated) {
        const sanitizedQuestion = {
          id: translated.id,
          text: translated.text,
          answers: translated.answers.map(a => ({ id: a.id, text: a.text })),
          currentNumber: poll.currentQuestion + 1,
          totalQuestions: poll.settings.nrOfQuestions
        };

        socket.emit('questionUpdate', sanitizedQuestion);
      }
    }
  });

  function startTimer(pollId, difficulty) {
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
      let poll = data.getPoll(pollId);
      if (poll) poll.currentTimer = timeLeft;

      io.to(pollId).emit('timerUpdate', timeLeft);

      if (timeLeft <= 0) {
        clearInterval(timers[pollId]);
        delete timers[pollId];
        endOfQuestion(io, data, pollId);
      }
    }, 1000);
  }

  socket.on('runQuestion', async function (d) {
    const poll = data.getPoll(d.pollId);
    if (!poll || !poll.settings) return;


    if (poll.currentQuestion + 1 >= poll.settings.nrOfQuestions) {
      return;
    }

    poll.currentQuestion++;

    const usedIds = poll.questions.map(q => q.id);
    const question = await data.getRandomQuestion(
      poll.lang || "sv",
      usedIds
    );

    if (!question) return;

    data.addQuestion(d.pollId, question);

    const sanitizedQuestion = {
      id: question.id,
      text: question.text,
      answers: question.answers.map(a => ({
        id: a.id,
        text: a.text
      })),
      currentNumber: poll.currentQuestion + 1,
      totalQuestions: poll.settings.nrOfQuestions
    };

    io.to(d.pollId).emit('questionUpdate', sanitizedQuestion);
    io.to(d.pollId).emit('submittedAnswersUpdate', {});
    io.to(d.pollId).emit('hideResults');

    startTimer(d.pollId, poll.settings.difficulty);
  });


  function endOfQuestion(io, data, pollId) {
    const poll = data.getPoll(pollId);
    const correctId = data.getCorrectAnswerId(pollId);

    io.to(pollId).emit('showResults', correctId);

    if (poll.currentQuestion + 1 >= poll.settings.nrOfQuestions) {
      setTimeout(() => {
        io.to(pollId).emit('gameOver');
      }, 2000);
    }
  }
};

export { sockets };