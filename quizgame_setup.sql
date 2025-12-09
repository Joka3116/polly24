DROP DATABASE IF EXISTS quizgame;
CREATE DATABASE quizgame;
USE quizgame;

SET SQL_SAFE_UPDATES = 0;

CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE questions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    language VARCHAR(2) NOT NULL,
    category_id INT,
    text VARCHAR(255) NOT NULL,
    difficulty INT DEFAULT 1,
    shared_question_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(id)
) ENGINE=InnoDB;

CREATE TABLE answers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    question_id INT NOT NULL,
    answer_text VARCHAR(255) NOT NULL,
    is_correct BOOLEAN NOT NULL,
    FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE games (
    id INT AUTO_INCREMENT PRIMARY KEY,
    selected_category_id INT,
    current_question_id INT,
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (selected_category_id) REFERENCES categories(id),
    FOREIGN KEY (current_question_id) REFERENCES questions(id)
) ENGINE=InnoDB;

CREATE TABLE players (
    id INT AUTO_INCREMENT PRIMARY KEY,
    game_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    score INT DEFAULT 0,
    has_double_points BOOLEAN DEFAULT 0,
    has_steal_points BOOLEAN DEFAULT 0,
    FOREIGN KEY (game_id) REFERENCES games(id) ON DELETE CASCADE
) ENGINE=InnoDB;

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vad är Sveriges huvudstad?', 1, 1);
SET @sv_q1 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q1, 'Stockholm', 1),
(@sv_q1, 'Göteborg', 0),
(@sv_q1, 'Malmö', 0),
(@sv_q1, 'Uppsala', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'What is the capital of Sweden?', 1, 1);
SET @en_q1 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q1, 'Stockholm', 1),
(NULL, @en_q1, 'Gothenburg', 0),
(NULL, @en_q1, 'Malmo', 0),
(NULL, @en_q1, 'Uppsala', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vilket år började andra världskriget?', 1, 2);
SET @sv_q2 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @sv_q2, '1939', 1),
(NULL, @sv_q2, '1941', 0),
(NULL, @sv_q2, '1933', 0),
(NULL, @sv_q2, '1945', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'What year did World War II begin?', 1, 2);
SET @en_q2 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q2, '1939', 1),
(NULL, @en_q2, '1941', 0),
(NULL, @en_q2, '1933', 0),
(NULL, @en_q2, '1945', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vilket djur är störst i världen?', 1, 3);
SET @sv_q3 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @sv_q3, 'Blåval', 1),
(NULL, @sv_q3, 'Elefant', 0),
(NULL, @sv_q3, 'Kaskelot', 0),
(NULL, @sv_q3, 'Vithaj', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'Which animal is the largest in the world?', 1, 3);
SET @en_q3 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q3, 'Blue whale', 1),
(NULL, @en_q3, 'Elephant', 0),
(NULL, @en_q3, 'Sperm whale', 0),
(NULL, @en_q3, 'Great white shark', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Hur många spelare finns på planen i ett fotbollslag?', 1, 4);
SET @sv_q4 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @sv_q4, '11', 1),
(NULL, @sv_q4, '10', 0),
(NULL, @sv_q4, '12', 0),
(NULL, @sv_q4, '9', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'How many players are on the field in a football team?', 1, 4);
SET @en_q4 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q4, '11', 1),
(NULL, @en_q4, '10', 0),
(NULL, @en_q4, '12', 0),
(NULL, @en_q4, '9', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vilken planet kallas den röda planeten?', 1, 5);
SET @sv_q5 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @sv_q5, 'Mars', 1),
(NULL, @sv_q5, 'Venus', 0),
(NULL, @sv_q5, 'Jupiter', 0),
(NULL, @sv_q5, 'Saturnus', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'Which planet is known as the Red Planet?', 1, 5);
SET @en_q5 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q5, 'Mars', 1),
(NULL, @en_q5, 'Venus', 0),
(NULL, @en_q5, 'Jupiter', 0),
(NULL, @en_q5, 'Saturn', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Hur många minuter finns i en timme?', 1, 6);
SET @sv_q6 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @sv_q6, '60', 1),
(NULL, @sv_q6, '100', 0),
(NULL, @sv_q6, '45', 0),
(NULL, @sv_q6, '30', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'How many minutes are in an hour?', 1, 6);
SET @en_q6 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q6, '60', 1),
(NULL, @en_q6, '100', 0),
(NULL, @en_q6, '45', 0),
(NULL, @en_q6, '30', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vad heter Sveriges största sjö?', 1, 7);
SET @sv_q7 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @sv_q7, 'Vänern', 1),
(NULL, @sv_q7, 'Vättern', 0),
(NULL, @sv_q7, 'Mälaren', 0),
(NULL, @sv_q7, 'Hjälmaren', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'What is the largest lake in Sweden?', 1, 7);
SET @en_q7 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q7, 'Vänern', 1),
(NULL, @en_q7, 'Vättern', 0),
(NULL, @en_q7, 'Mälaren', 0),
(NULL, @en_q7, 'Hjälmaren', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vem skrev "Pippi Långstrump"?', 1, 8);
SET @sv_q8 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @sv_q8, 'Astrid Lindgren', 1),
(NULL, @sv_q8, 'Selma Lagerlöf', 0),
(NULL, @sv_q8, 'Tove Jansson', 0),
(NULL, @sv_q8, 'August Strindberg', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'Who wrote "Pippi Longstocking"?', 1, 8);
SET @en_q8 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q8, 'Astrid Lindgren', 1),
(NULL, @en_q8, 'Selma Lagerlöf', 0),
(NULL, @en_q8, 'Tove Jansson', 0),
(NULL, @en_q8, 'August Strindberg', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vilket grundämne har kemiska beteckningen O?', 1, 9);
SET @sv_q9 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @sv_q9, 'Syre', 1),
(NULL, @sv_q9, 'Guld', 0),
(NULL, @sv_q9, 'Silver', 0),
(NULL, @sv_q9, 'Kol', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'Which element has the chemical symbol O?', 1, 9);
SET @en_q9 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q9, 'Oxygen', 1),
(NULL, @en_q9, 'Gold', 0),
(NULL, @en_q9, 'Silver', 0),
(NULL, @en_q9, 'Carbon', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Hur många kontinenter finns det?', 1, 10);
SET @sv_q10 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @sv_q10, '7', 1),
(NULL, @sv_q10, '5', 0),
(NULL, @sv_q10, '6', 0),
(NULL, @sv_q10, '4', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'How many continents are there?', 1, 10);
SET @en_q10 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q10, '7', 1),
(NULL, @en_q10, '5', 0),
(NULL, @en_q10, '6', 0),
(NULL, @en_q10, '4', 0);
