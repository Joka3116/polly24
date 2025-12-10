'use strict';
import { readFileSync } from "fs";
import mysql from "mysql2/promise";

const pool = mysql.createPool({
  host: "localhost",
  user: "root",
  password: "YOUR_PASSWORD_HERE",
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
  console.log("participant will be added to", pollId, name);
  if (this.pollExists(pollId)) {
    // LÄGG TILL: isReady: false
    this.polls[pollId].participants.push({ name: name, answers: [], isReady: false });
  }
}
Data.prototype.setPlayerReady = function(pollId, name, isReady) {
  if (this.pollExists(pollId)) {
    const participants = this.polls[pollId].participants;
    // Hitta rätt deltagare och uppdatera status
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

Data.prototype.submitAnswer = function (pollId, answer) {
  if (this.pollExists(pollId)) {
    const poll = this.polls[pollId];
    let answers = poll.answers[poll.currentQuestion];
    // create answers object if no answers have yet been submitted
    if (typeof answers !== 'object') {
      answers = {};
      answers[answer] = 1;
      poll.answers.push(answers);
    }
    // create answer property if that specific answer has not yet been submitted
    else if (typeof answers[answer] === 'undefined') {
      answers[answer] = 1;
    }
    // if the property already exists, increase the number
    else
      answers[answer] += 1
    console.log("answers looks like ", answers, typeof answers);
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

export { Data };



