'use strict';
import { readFileSync } from "fs";
import mysql from "mysql2/promise";

const pool = mysql.createPool({
  host: "localhost",
  user: "root",
  password: "PaSswOrD",
  database: "quizgame"
});

function shuffleArray(arr) {
  return arr
    .map(a => ({ value: a, sort: Math.random() }))
    .sort((a, b) => a.sort - b.sort)
    .map(a => a.value);
}

// Store data in an object to keep the global namespace clean. In an actual implementation this would be interfacing a database...
function Data() {
  this.polls = {};
  this.polls['test'] = {
    lang: "en",
    questions: [
      {
        q: "How old are you?",
        a: ["0-13", "14-18", "19-25", "26-35", "36-45", "45-"]
      },
      {
        q: "How much do you enjoy coding?",
        a: ["1", "2", "3", "4", "5"]
      }
    ],
    answers: [],
    currentQuestion: 0,
    participants: []
  }
}

/***********************************************
For performance reasons, methods are added to the
prototype of the Data object/class
https://developer.mozilla.org/en-US/docs/Web/JavaScript/Closures
***********************************************/

Data.prototype.pollExists = function (pollId) {
  return typeof this.polls[pollId] !== "undefined"
}

Data.prototype.getUILabels = function (lang) {
  //check if lang is valid before trying to load the dictionary file
  if (!["en", "sv"].some(el => el === lang))
    lang = "en";
  const labels = readFileSync("./server/data/labels-" + lang + ".json");
  return JSON.parse(labels);
}

Data.prototype.createPoll = function (pollId, lang = "en") {
  if (!this.pollExists(pollId)) {
    let poll = {};
    poll.lang = lang;
    poll.questions = [];
    poll.answers = [];
    poll.participants = [];
    poll.currentQuestion = 0;
    this.polls[pollId] = poll;
    console.log("poll created", pollId, poll);
  }
  return this.polls[pollId];
}

Data.prototype.saveSettings = function (pollId, settings) {
  if (this.pollExists(pollId)) {
    this.polls[pollId].settings = settings;
    console.log("Settings saved for", pollId, settings);
  }
}

Data.prototype.getPoll = function (pollId) {
  if (this.pollExists(pollId)) {
    return this.polls[pollId];
  }
  return {};
}

Data.prototype.participateInPoll = function (pollId, name) {
  if (this.pollExists(pollId)) {
    this.polls[pollId].participants.push({ 
      name: name, 
      answers: [], 
      isReady: false, 
      points: 0       
    });
  }
}

Data.prototype.setPlayerReady = function (pollId, name, isReady) {
  if (this.pollExists(pollId)) {
    const participants = this.polls[pollId].participants;
  
    const participant = participants.find(p => p.name === name);
    if (participant) {
      participant.isReady = isReady;
    }
  }
}

Data.prototype.getParticipants = function (pollId) {
  const poll = this.polls[pollId];
  console.log("participants requested for", pollId);
  if (this.pollExists(pollId)) {
    return this.polls[pollId].participants
  }
  return [];
}

Data.prototype.addQuestion = function (pollId, q) {
  if (this.pollExists(pollId)) {
    this.polls[pollId].questions.push(q);
  }
}

Data.prototype.getAnsweredCount = function (pollId) {
  if (this.pollExists(pollId)) {
    const poll = this.polls[pollId];
    return poll.participants.filter(p => p.answers[poll.currentQuestion] !== undefined).length;
  }
  return 0;
};

Data.prototype.getSubmittedAnswers = function (pollId) {
  if (this.pollExists(pollId)) {
    const poll = this.polls[pollId];
    const answers = poll.answers[poll.currentQuestion];
    if (typeof poll.questions[poll.currentQuestion] !== 'undefined') {
      return answers;
    }
  }
  return {}
}

Data.prototype.submitAnswer = function (pollId, name, answer, timeLeft) {
  if (this.pollExists(pollId)) {
    const poll = this.polls[pollId];
    const participant = poll.participants.find(p => p.name === name);
    const question = poll.questions[poll.currentQuestion];

    if (participant) {
      participant.answers[poll.currentQuestion] = answer;

  
      const selectedOption = question.answers.find(a => 
        a.text.toString().trim().toLowerCase() === answer.toString().trim().toLowerCase()
      );


      if (selectedOption && selectedOption.is_correct == 1) {
        const pointsEarned = Math.round(timeLeft * 100);
        participant.points += pointsEarned;
        console.log(`KORREKT! ${name} tjänade ${pointsEarned} Cash. Totalt: ${participant.points}`);
      } else {
        console.log(`FEL SVAR från ${name}. Han valde: ${answer}`);
      }
    }

    // Statistik-logik för stapeldiagram
    if (typeof poll.answers[poll.currentQuestion] !== 'object') {
      poll.answers[poll.currentQuestion] = {};
    }
    let currentAnswers = poll.answers[poll.currentQuestion];
    currentAnswers[answer] = (currentAnswers[answer] || 0) + 1;
  }
}

Data.prototype.getRandomQuestion = async function (language = "sv") {

  const [questions] = await pool.query(
    `SELECT id, shared_question_id, text
     FROM questions
     WHERE language = ?
     ORDER BY RAND()
     LIMIT 1`,
    [language]
  );

  const q = questions[0];


  const [answers] = await pool.query(
    `SELECT id, answer_text AS text, is_correct
     FROM answers
     WHERE question_id = ?`,
    [q.id]
  );


  return {
    id: q.id,
    sharedId: q.shared_question_id,
    text: q.text,
    answers: shuffleArray(answers) 
  };
};
Data.prototype.nameAvailable = function (pollId, name) {
  if (this.pollExists(pollId)) {

    const exists = this.polls[pollId].participants.some(
      p => p.name.toLowerCase() === name.toLowerCase()
    );
    return !exists; 
  }
  return true;
};

export { Data };



