let timers = {};

function sockets(io, socket, data) {

  socket.on('createPoll', (d) => {
    data.createPoll(d.pollId, d.lang);
    const poll = data.getPoll(d.pollId);
    poll.scores = {};
    poll.answered = {};
  });

  socket.on('checkPollExists', (pollId) => {
    const exists = data.pollExists(pollId);
    socket.emit('pollExistsResponse', exists);
  });

  socket.on("startPoll", async ({ pollId, language }) => {
    const poll = data.getPoll(pollId);
    if (!poll) return;

    io.to(pollId).emit("startPoll");

    const question = await data.getRandomQuestion(language || poll.lang || "sv");
    data.addQuestion(pollId, question);

    poll.answered = {};

    io.to(pollId).emit("questionUpdate", question);
    io.to(pollId).emit("hideResults");

    startTimer(pollId, poll.settings?.difficulty || "medium");
  });


  socket.on("participateInPoll", (d) => {
    if (!data.pollExists(d.pollId)) return;

    socket.join(d.pollId);

    if (data.nameAvailable(d.pollId, d.name)) {
      data.participateInPoll(d.pollId, d.name);

      io.to(d.pollId).emit(
        "participantsUpdate",
        data.getParticipants(d.pollId)
      );

      socket.emit("joinSuccess");
    } else {
      socket.emit("nameTaken");
    }
  });

  socket.on("playerReady", (d) => {
    data.setPlayerReady(d.pollId, d.name, d.isReady);

    io.to(d.pollId).emit(
      "participantsUpdate",
      data.getParticipants(d.pollId)
    );
  });


  socket.on("joinPoll", (pollId) => {
    socket.join(pollId);

    socket.emit(
      "participantsUpdate",
      data.getParticipants(pollId)
    );
  });


  socket.on('submitAnswer', ({ pollId, questionId, answerId, timeLeft }) => {
    const poll = data.getPoll(pollId);
    if (!poll) return;

    poll.answered = poll.answered || {};
    if (poll.answered[socket.id]) return;

    poll.answered[socket.id] = true;

    const question = poll.questions[poll.questions.length - 1];
    if (!question) return;

    if (question.correctAnswerId === answerId) {
      poll.scores[socket.id] =
        (poll.scores[socket.id] || 0) + 1;
    }

    io.to(pollId).emit("scoreUpdate", poll.scores);
  });

  socket.on('runQuestion', async ({ pollId }) => {
    const poll = data.getPoll(pollId);
    if (!poll || !poll.settings) return;

    if (poll.questions.length >= poll.settings.nrOfQuestions) {
      io.to(pollId).emit('gameOver');
      return;
    }

    const question = await data.getRandomQuestion(poll.lang || "sv");
    data.addQuestion(pollId, question);

    poll.answered = {};

    io.to(pollId).emit('questionUpdate', question);
    io.to(pollId).emit('hideResults');

    startTimer(pollId, poll.settings.difficulty);
  });

  socket.on('showResults', ({ pollId }) => {
    if (timers[pollId]) {
      clearInterval(timers[pollId]);
      delete timers[pollId];
    }

    const poll = data.getPoll(pollId);
    if (poll && poll.questions.length > 0) {
      const question = poll.questions[poll.questions.length - 1];
      io.to(pollId).emit("questionResult", {
        correctAnswerId: question.correctAnswerId
      });
    }

    io.to(pollId).emit('showResults');
  });

  function startTimer(pollId, difficulty) {
    if (timers[pollId]) {
      clearInterval(timers[pollId]);
      delete timers[pollId];
    }

    const times = { easy: 60, medium: 45, hard: 30 };
    let timeLeft = times[difficulty] || 45;

    io.to(pollId).emit('timerUpdate', timeLeft);

    timers[pollId] = setInterval(() => {
      timeLeft--;
      io.to(pollId).emit('timerUpdate', timeLeft);

      if (timeLeft <= 0) {
        clearInterval(timers[pollId]);
        delete timers[pollId];

        const poll = data.getPoll(pollId);
        if (poll && poll.questions.length > 0) {
          const question = poll.questions[poll.questions.length - 1];
          io.to(pollId).emit("questionResult", {
            correctAnswerId: question.correctAnswerId
          });
        }

        io.to(pollId).emit('showResults');
      }
    }, 1000);
  }
}

export { sockets };