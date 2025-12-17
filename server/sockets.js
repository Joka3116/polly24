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
    data.participateInPoll(d.pollId, d.name);
    io.to(d.pollId).emit('participantsUpdate', data.getParticipants(d.pollId));
  });
  socket.on('playerReady', function (d) {
    data.setPlayerReady(d.pollId, d.name, d.isReady);
    io.to(d.pollId).emit('participantsUpdate', data.getParticipants(d.pollId));
  });

  socket.on('startPoll', async function (d) {
    data.saveSettings(d.pollId, {
      nrOfQuestions: d.nrOfQuestions,
      difficulty: d.difficulty
    });
    io.to(d.pollId).emit('startPoll', d.pollId);
    let question = await data.getRandomQuestion(d.language || "en");
    data.addQuestion(d.pollId, question);
    if (data.polls[d.pollId]) {
      data.polls[d.pollId].answers = [];
    }
    io.to(d.pollId).emit('questionUpdate', question);
    io.to(d.pollId).emit('submittedAnswersUpdate', {});
  })

  socket.on('runQuestion', async function (d) {
    let poll = data.getPoll(d.pollId);
    
    if (poll.settings && poll.questions.length >= poll.settings.nrOfQuestions) {
      io.to(d.pollId).emit('gameOver', { reason: 'Limit reached' });
      return;
    }
    let question = await data.getRandomQuestion(d.language || "sv");
    data.addQuestion(d.pollId, question);
    data.polls[d.pollId].answers = [];
    io.to(d.pollId).emit('questionUpdate', question);
    io.to(d.pollId).emit('submittedAnswersUpdate', {});
  });

  socket.on('submitAnswer', function (d) {
    data.submitAnswer(d.pollId, d.answer);
    io.to(d.pollId).emit('submittedAnswersUpdate', data.getSubmittedAnswers(d.pollId));
  });
  socket.on('showResults', function (d) {
  io.to(d.pollId).emit('showResults');
});
}

export { sockets };