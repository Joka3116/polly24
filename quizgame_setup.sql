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
VALUES ('sv', NULL, 'Vilken svensk kemist uppfann dynamiten?', 2, 1);
SET @sv_q1 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q1, 'Alfred Nobel', 1),
(@sv_q1, 'Anders Celsius', 0),
(@sv_q1, 'Carl von Linné', 0),
(@sv_q1, 'Svante Arrhenius', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'Which Swedish chemist invented dynamite?', 2, 1);
SET @en_q1 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q1, 'Alfred Nobel', 1),
(NULL, @en_q1, 'Anders Celsius', 0),
(NULL, @en_q1, 'Carl von Linnaeus', 0),
(NULL, @en_q1, 'Svante Arrhenius', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vilket år sjönk fartyget Titanic?', 2, 2);
SET @sv_q2 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q2, '1912', 1),
(@sv_q2, '1908', 0),
(@sv_q2, '1914', 0),
(@sv_q2, '1920', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'In what year did the Titanic sink?', 2, 2);
SET @en_q2 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q2, '1912', 1),
(NULL, @en_q2, '1908', 0),
(NULL, @en_q2, '1914', 0),
(NULL, @en_q2, '1920', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vilken är den vanligaste gasen i jordens atmosfär?', 2, 3);
SET @sv_q3 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q3, 'Kväve', 1),
(@sv_q3, 'Syre', 0),
(@sv_q3, 'Koldioxid', 0),
(@sv_q3, 'Väte', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'What is the most common gas in Earth\'s atmosphere?', 2, 3);
SET @en_q3 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q3, 'Nitrogen', 1),
(NULL, @en_q3, 'Oxygen', 0),
(NULL, @en_q3, 'Carbon Dioxide', 0),
(NULL, @en_q3, 'Hydrogen', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vem skrev romanen "Brott och straff"?', 2, 4);
SET @sv_q4 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q4, 'Fjodor Dostojevskij', 1),
(@sv_q4, 'Leo Tolstoj', 0),
(@sv_q4, 'Anton Tjechov', 0),
(@sv_q4, 'Maxim Gorkij', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'Who wrote the novel "Crime and Punishment"?', 2, 4);
SET @en_q4 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q4, 'Fyodor Dostoevsky', 1),
(NULL, @en_q4, 'Leo Tolstoy', 0),
(NULL, @en_q4, 'Anton Chekhov', 0),
(NULL, @en_q4, 'Maxim Gorky', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vilket organ i kroppen producerar insulin?', 2, 5);
SET @sv_q5 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q5, 'Bukspottkörteln', 1),
(@sv_q5, 'Levern', 0),
(@sv_q5, 'Njuren', 0),
(@sv_q5, 'Mjälten', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'Which organ in the body produces insulin?', 2, 5);
SET @en_q5 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q5, 'Pancreas', 1),
(NULL, @en_q5, 'Liver', 0),
(NULL, @en_q5, 'Kidney', 0),
(NULL, @en_q5, 'Spleen', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vilken är världens största öken?', 2, 6);
SET @sv_q6 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q6, 'Antarktis', 1),
(@sv_q6, 'Sahara', 0),
(@sv_q6, 'Gobiöknen', 0),
(@sv_q6, 'Kalahariöknen', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'What is the largest desert in the world?', 2, 6);
SET @en_q6 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q6, 'Antarctica', 1),
(NULL, @en_q6, 'Sahara', 0),
(NULL, @en_q6, 'Gobi Desert', 0),
(NULL, @en_q6, 'Kalahari Desert', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vem var den första personen att nå Sydpolen?', 2, 7);
SET @sv_q7 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q7, 'Roald Amundsen', 1),
(@sv_q7, 'Robert Falcon Scott', 0),
(@sv_q7, 'Ernest Shackleton', 0),
(@sv_q7, 'Fridtjof Nansen', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'Who was the first person to reach the South Pole?', 2, 7);
SET @en_q7 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q7, 'Roald Amundsen', 1),
(NULL, @en_q7, 'Robert Falcon Scott', 0),
(NULL, @en_q7, 'Ernest Shackleton', 0),
(NULL, @en_q7, 'Fridtjof Nansen', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vad är kvadratroten ur 225?', 2, 8);
SET @sv_q8 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q8, '15', 1),
(@sv_q8, '13', 0),
(@sv_q8, '17', 0),
(@sv_q8, '25', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'What is the square root of 225?', 2, 8);
SET @en_q8 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q8, '15', 1),
(NULL, @en_q8, '13', 0),
(NULL, @en_q8, '17', 0),
(NULL, @en_q8, '25', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vilket krig avslutades genom Versaillesfreden?', 2, 9);
SET @sv_q9 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q9, 'Första världskriget', 1),
(@sv_q9, 'Andra världskriget', 0),
(@sv_q9, 'Fransk-tyska kriget', 0),
(@sv_q9, 'Trettioåriga kriget', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'Which war was ended by the Treaty of Versailles?', 2, 9);
SET @en_q9 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q9, 'World War I', 1),
(NULL, @en_q9, 'World War II', 0),
(NULL, @en_q9, 'Franco-Prussian War', 0),
(NULL, @en_q9, 'Thirty Years\' War', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vilken är Europas längsta flod?', 2, 10);
SET @sv_q10 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q10, 'Volga', 1),
(@sv_q10, 'Donau', 0),
(@sv_q10, 'Rhen', 0),
(@sv_q10, 'Elbe', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'What is the longest river in Europe?', 2, 10);
SET @en_q10 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q10, 'Volga', 1),
(NULL, @en_q10, 'Danube', 0),
(NULL, @en_q10, 'Rhine', 0),
(NULL, @en_q10, 'Elbe', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vilket är det kemiska tecknet för Tenn?', 2, 11);
SET @sv_q11 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q11, 'Sn', 1),
(@sv_q11, 'Ti', 0),
(@sv_q11, 'Te', 0),
(@sv_q11, 'Pb', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'What is the chemical symbol for Tin?', 2, 11);
SET @en_q11 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q11, 'Sn', 1),
(NULL, @en_q11, 'Ti', 0),
(NULL, @en_q11, 'Te', 0),
(NULL, @en_q11, 'Pb', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vem målade verket "Flickan med pärlörhänge"?', 2, 12);
SET @sv_q12 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q12, 'Johannes Vermeer', 1),
(@sv_q12, 'Rembrandt', 0),
(@sv_q12, 'Vincent van Gogh', 0),
(@sv_q12, 'Jan van Eyck', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'Who painted "The Girl with a Pearl Earring"?', 2, 12);
SET @en_q12 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q12, 'Johannes Vermeer', 1),
(NULL, @en_q12, 'Rembrandt', 0),
(NULL, @en_q12, 'Vincent van Gogh', 0),
(NULL, @en_q12, 'Jan van Eyck', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vilken är Australiens huvudstad?', 2, 13);
SET @sv_q13 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q13, 'Canberra', 1),
(@sv_q13, 'Sydney', 0),
(@sv_q13, 'Melbourne', 0),
(@sv_q13, 'Perth', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'What is the capital city of Australia?', 2, 13);
SET @en_q13 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q13, 'Canberra', 1),
(NULL, @en_q13, 'Sydney', 0),
(NULL, @en_q13, 'Melbourne', 0),
(NULL, @en_q13, 'Perth', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vilken elektrisk laddning har en proton?', 2, 14);
SET @sv_q14 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q14, 'Positiv', 1),
(@sv_q14, 'Negativ', 0),
(@sv_q14, 'Neutral', 0),
(@sv_q14, 'Varierande', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'What electrical charge does a proton have?', 2, 14);
SET @en_q14 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q14, 'Positive', 1),
(NULL, @en_q14, 'Negative', 0),
(NULL, @en_q14, 'Neutral', 0),
(NULL, @en_q14, 'Variable', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'I vilket land ligger ruinerna av Machu Picchu?', 2, 15);
SET @sv_q15 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q15, 'Peru', 1),
(@sv_q15, 'Chile', 0),
(@sv_q15, 'Bolivia', 0),
(@sv_q15, 'Ecuador', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'In which country is the ruins of Machu Picchu located?', 2, 15);
SET @en_q15 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q15, 'Peru', 1),
(NULL, @en_q15, 'Chile', 0),
(NULL, @en_q15, 'Bolivia', 0),
(NULL, @en_q15, 'Ecuador', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vem upptäckte penicillinet?', 2, 16);
SET @sv_q16 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q16, 'Alexander Fleming', 1),
(@sv_q16, 'Louis Pasteur', 0),
(@sv_q16, 'Marie Curie', 0),
(@sv_q16, 'Robert Koch', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'Who discovered penicillin?', 2, 16);
SET @en_q16 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q16, 'Alexander Fleming', 1),
(NULL, @en_q16, 'Louis Pasteur', 0),
(NULL, @en_q16, 'Marie Curie', 0),
(NULL, @en_q16, 'Robert Koch', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vilket är det hårdaste naturligt förekommande ämnet på jorden?', 2, 17);
SET @sv_q17 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q17, 'Diamant', 1),
(@sv_q17, 'Guld', 0),
(@sv_q17, 'Järn', 0),
(@sv_q17, 'Kvart', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'What is the hardest natural substance on Earth?', 2, 17);
SET @en_q17 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q17, 'Diamond', 1),
(NULL, @en_q17, 'Gold', 0),
(NULL, @en_q17, 'Iron', 0),
(NULL, @en_q17, 'Quartz', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Hur många tangenter har ett standardpiano?', 2, 18);
SET @sv_q18 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q18, '88', 1),
(@sv_q18, '76', 0),
(@sv_q18, '92', 0),
(@sv_q18, '84', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'How many keys are on a standard piano?', 2, 18);
SET @en_q18 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q18, '88', 1),
(NULL, @en_q18, '76', 0),
(NULL, @en_q18, '92', 0),
(NULL, @en_q18, '84', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Ungefär vad är ljusets hastighet i vakuum?', 2, 19);
SET @sv_q19 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q19, '300 000 km/s', 1),
(@sv_q19, '150 000 km/s', 0),
(@sv_q19, '1 000 000 km/s', 0),
(@sv_q19, '343 m/s', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'Approximately what is the speed of light in a vacuum?', 2, 19);
SET @en_q19 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q19, '300,000 km/s', 1),
(NULL, @en_q19, '150,000 km/s', 0),
(NULL, @en_q19, '1,000,000 km/s', 0),
(NULL, @en_q19, '343 m/s', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vem skrev sagan om "Den lilla sjöjungfrun"?', 2, 20);
SET @sv_q20 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q20, 'H.C. Andersen', 1),
(@sv_q20, 'Bröderna Grimm', 0),
(@sv_q20, 'Astrid Lindgren', 0),
(@sv_q20, 'Charles Perrault', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'Who wrote the fairy tale "The Little Mermaid"?', 2, 20);
SET @en_q20 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q20, 'H.C. Andersen', 1),
(NULL, @en_q20, 'The Brothers Grimm', 0),
(NULL, @en_q20, 'Astrid Lindgren', 0),
(NULL, @en_q20, 'Charles Perrault', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vilken stad är Turkiets huvudstad?', 2, 21);
SET @sv_q21 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q21, 'Ankara', 1),
(@sv_q21, 'Istanbul', 0),
(@sv_q21, 'Izmir', 0),
(@sv_q21, 'Antalya', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'Which city is the capital of Turkey?', 2, 21);
SET @en_q21 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q21, 'Ankara', 1),
(NULL, @en_q21, 'Istanbul', 0),
(NULL, @en_q21, 'Izmir', 0),
(NULL, @en_q21, 'Antalya', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vem formulerade evolutionsteorin genom naturligt urval?', 2, 22);
SET @sv_q22 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q22, 'Charles Darwin', 1),
(@sv_q22, 'Gregor Mendel', 0),
(@sv_q22, 'Jean-Baptiste Lamarck', 0),
(@sv_q22, 'Alfred Russel Wallace', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'Who formulated the theory of evolution by natural selection?', 2, 22);
SET @en_q22 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q22, 'Charles Darwin', 1),
(NULL, @en_q22, 'Gregor Mendel', 0),
(NULL, @en_q22, 'Jean-Baptiste Lamarck', 0),
(NULL, @en_q22, 'Alfred Russel Wallace', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vem var den första människan i rymden?', 2, 23);
SET @sv_q23 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q23, 'Jurij Gagarin', 1),
(@sv_q23, 'Neil Armstrong', 0),
(@sv_q23, 'Buzz Aldrin', 0),
(@sv_q23, 'John Glenn', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'Who was the first human in space?', 2, 23);
SET @en_q23 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q23, 'Yuri Gagarin', 1),
(NULL, @en_q23, 'Neil Armstrong', 0),
(NULL, @en_q23, 'Buzz Aldrin', 0),
(NULL, @en_q23, 'John Glenn', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vilket är det kemiska tecknet för silver?', 2, 24);
SET @sv_q24 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q24, 'Ag', 1),
(@sv_q24, 'Si', 0),
(@sv_q24, 'Au', 0),
(@sv_q24, 'Sl', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'What is the chemical symbol for silver?', 2, 24);
SET @en_q24 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q24, 'Ag', 1),
(NULL, @en_q24, 'Si', 0),
(NULL, @en_q24, 'Au', 0),
(NULL, @en_q24, 'Sl', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vem skrev romanen "Den store Gatsby"?', 2, 25);
SET @sv_q25 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q25, 'F. Scott Fitzgerald', 1),
(@sv_q25, 'Ernest Hemingway', 0),
(@sv_q25, 'William Faulkner', 0),
(@sv_q25, 'John Steinbeck', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'Who wrote the novel "The Great Gatsby"?', 2, 25);
SET @en_q25 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q25, 'F. Scott Fitzgerald', 1),
(NULL, @en_q25, 'Ernest Hemingway', 0),
(NULL, @en_q25, 'William Faulkner', 0),
(NULL, @en_q25, 'John Steinbeck', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vilket land har den största landytan i världen?', 2, 26);
SET @sv_q26 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q26, 'Ryssland', 1),
(@sv_q26, 'Kanada', 0),
(@sv_q26, 'Kina', 0),
(@sv_q26, 'USA', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'Which country has the largest land area in the world?', 2, 26);
SET @en_q26 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q26, 'Russia', 1),
(NULL, @en_q26, 'Canada', 0),
(NULL, @en_q26, 'China', 0),
(NULL, @en_q26, 'USA', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Hur många planeter finns det i vårt solsystem?', 2, 27);
SET @sv_q27 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q27, '8', 1),
(@sv_q27, '9', 0),
(@sv_q27, '7', 0),
(@sv_q27, '10', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'How many planets are there in our solar system?', 2, 27);
SET @en_q27 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q27, '8', 1),
(NULL, @en_q27, '9', 0),
(NULL, @en_q27, '7', 0),
(NULL, @en_q27, '10', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vem uppfann den första praktiska glödlampan?', 2, 28);
SET @sv_q28 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q28, 'Thomas Edison', 1),
(@sv_q28, 'Nikola Tesla', 0),
(@sv_q28, 'Alexander Graham Bell', 0),
(@sv_q28, 'Benjamin Franklin', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'Who invented the first practical light bulb?', 2, 28);
SET @en_q28 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q28, 'Thomas Edison', 1),
(NULL, @en_q28, 'Nikola Tesla', 0),
(NULL, @en_q28, 'Alexander Graham Bell', 0),
(NULL, @en_q28, 'Benjamin Franklin', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vilken stad är Brasiliens huvudstad?', 2, 29);
SET @sv_q29 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q29, 'Brasília', 1),
(@sv_q29, 'Rio de Janeiro', 0),
(@sv_q29, 'São Paulo', 0),
(@sv_q29, 'Salvador', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'Which city is the capital of Brazil?', 2, 29);
SET @en_q29 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q29, 'Brasília', 1),
(NULL, @en_q29, 'Rio de Janeiro', 0),
(NULL, @en_q29, 'São Paulo', 0),
(NULL, @en_q29, 'Salvador', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vad heter valutan i Japan?', 2, 30);
SET @sv_q30 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q30, 'Yen', 1),
(@sv_q30, 'Won', 0),
(@sv_q30, 'Yuan', 0),
(@sv_q30, 'Baht', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'What is the currency of Japan?', 2, 30);
SET @en_q30 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q30, 'Yen', 1),
(NULL, @en_q30, 'Won', 0),
(NULL, @en_q30, 'Yuan', 0),
(NULL, @en_q30, 'Baht', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vilka är de tre primärfärgerna i subtraktiv färgblandning (pigment)?', 2, 31);
SET @sv_q31 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q31, 'Röd, blå, gul', 1),
(@sv_q31, 'Röd, grön, blå', 0),
(@sv_q31, 'Orange, lila, grön', 0),
(@sv_q31, 'Svart, vit, grå', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'What are the three primary colors in subtractive color mixing (pigments)?', 2, 31);
SET @en_q31 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q31, 'Red, blue, yellow', 1),
(NULL, @en_q31, 'Red, green, blue', 0),
(NULL, @en_q31, 'Orange, purple, green', 0),
(NULL, @en_q31, 'Black, white, gray', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vilket är Afrikas högsta berg?', 2, 32);
SET @sv_q32 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q32, 'Kilimanjaro', 1),
(@sv_q32, 'Mount Kenya', 0),
(@sv_q32, 'Atlasbergen', 0),
(@sv_q32, 'Mount Stanley', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'What is the highest mountain in Africa?', 2, 32);
SET @en_q32 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q32, 'Kilimanjaro', 1),
(NULL, @en_q32, 'Mount Kenya', 0),
(NULL, @en_q32, 'Atlas Mountains', 0),
(NULL, @en_q32, 'Mount Stanley', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vem målade det berömda konstverket "Stjärnenatt"?', 2, 33);
SET @sv_q33 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q33, 'Vincent van Gogh', 1),
(@sv_q33, 'Claude Monet', 0),
(@sv_q33, 'Salvador Dalí', 0),
(@sv_q33, 'Paul Cézanne', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'Who painted the famous artwork "The Starry Night"?', 2, 33);
SET @en_q33 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q33, 'Vincent van Gogh', 1),
(NULL, @en_q33, 'Claude Monet', 0),
(NULL, @en_q33, 'Salvador Dalí', 0),
(NULL, @en_q33, 'Paul Cézanne', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vilken är världens största nu levande fågel?', 2, 34);
SET @sv_q34 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q34, 'Struts', 1),
(@sv_q34, 'Emu', 0),
(@sv_q34, 'Kondor', 0),
(@sv_q34, 'Albatross', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'What is the largest living bird in the world?', 2, 34);
SET @en_q34 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q34, 'Ostrich', 1),
(NULL, @en_q34, 'Emu', 0),
(NULL, @en_q34, 'Condor', 0),
(NULL, @en_q34, 'Albatross', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vilket år landsteg Christofer Columbus för första gången i Amerika?', 2, 35);
SET @sv_q35 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q35, '1492', 1),
(@sv_q35, '1488', 0),
(@sv_q35, '1501', 0),
(@sv_q35, '1453', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'In what year did Christopher Columbus first land in the Americas?', 2, 35);
SET @en_q35 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q35, '1492', 1),
(NULL, @en_q35, '1488', 0),
(NULL, @en_q35, '1501', 0),
(NULL, @en_q35, '1453', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vilket grundämne har det kemiska tecknet K?', 2, 36);
SET @sv_q36 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q36, 'Kalium', 1),
(@sv_q36, 'Kalcium', 0),
(@sv_q36, 'Koppar', 0),
(@sv_q36, 'Krypton', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'Which element has the chemical symbol K?', 2, 36);
SET @en_q36 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q36, 'Potassium', 1),
(NULL, @en_q36, 'Calcium', 0),
(NULL, @en_q36, 'Copper', 0),
(NULL, @en_q36, 'Krypton', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vem skrev den dystopiska romanen "Du sköna nya värld" (Brave New World)?', 2, 37);
SET @sv_q37 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q37, 'Aldous Huxley', 1),
(@sv_q37, 'George Orwell', 0),
(@sv_q37, 'Ray Bradbury', 0),
(@sv_q37, 'Anthony Burgess', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'Who wrote the dystopian novel "Brave New World"?', 2, 37);
SET @en_q37 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q37, 'Aldous Huxley', 1),
(NULL, @en_q37, 'George Orwell', 0),
(NULL, @en_q37, 'Ray Bradbury', 0),
(NULL, @en_q37, 'Anthony Burgess', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vilken stad är Schweiz de facto huvudstad?', 2, 38);
SET @sv_q38 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q38, 'Bern', 1),
(@sv_q38, 'Zürich', 0),
(@sv_q38, 'Genève', 0),
(@sv_q38, 'Basel', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'Which city is the de facto capital of Switzerland?', 2, 38);
SET @en_q38 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q38, 'Bern', 1),
(NULL, @en_q38, 'Zurich', 0),
(NULL, @en_q38, 'Geneva', 0),
(NULL, @en_q38, 'Basel', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Ungefär vad är ljudets hastighet i torr luft vid havsnivå?', 2, 39);
SET @sv_q39 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q39, '343 m/s', 1),
(@sv_q39, '150 m/s', 0),
(@sv_q39, '500 m/s', 0),
(@sv_q39, '1200 m/s', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'Approximately what is the speed of sound in dry air at sea level?', 2, 39);
SET @en_q39 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q39, '343 m/s', 1),
(NULL, @en_q39, '150 m/s', 0),
(NULL, @en_q39, '500 m/s', 0),
(NULL, @en_q39, '1200 m/s', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vilket är det största nu levande däggdjuret?', 2, 40);
SET @sv_q40 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q40, 'Blåval', 1),
(@sv_q40, 'Afrikansk elefant', 0),
(@sv_q40, 'Kaskelot', 0),
(@sv_q40, 'Finval', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'What is the largest living mammal?', 2, 40);
SET @en_q40 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q40, 'Blue Whale', 1),
(NULL, @en_q40, 'African Elephant', 0),
(NULL, @en_q40, 'Sperm Whale', 0),
(NULL, @en_q40, 'Fin Whale', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Hur många delstater består USA av?', 2, 41);
SET @sv_q41 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q41, '50', 1),
(@sv_q41, '52', 0),
(@sv_q41, '48', 0),
(@sv_q41, '51', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'How many states make up the United States?', 2, 41);
SET @en_q41 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q41, '50', 1),
(NULL, @en_q41, '52', 0),
(NULL, @en_q41, '48', 0),
(NULL, @en_q41, '51', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vilket är det kemiska tecknet för järn?', 2, 42);
SET @sv_q42 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q42, 'Fe', 1),
(@sv_q42, 'Ir', 0),
(@sv_q42, 'In', 0),
(@sv_q42, 'Pb', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'What is the chemical symbol for iron?', 2, 42);
SET @en_q42 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q42, 'Fe', 1),
(NULL, @en_q42, 'Ir', 0),
(NULL, @en_q42, 'In', 0),
(NULL, @en_q42, 'Pb', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vilken stad är Egyptens huvudstad?', 2, 43);
SET @sv_q43 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q43, 'Kairo', 1),
(@sv_q43, 'Alexandria', 0),
(@sv_q43, 'Giza', 0),
(@sv_q43, 'Luxor', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'Which city is the capital of Egypt?', 2, 43);
SET @en_q43 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q43, 'Cairo', 1),
(NULL, @en_q43, 'Alexandria', 0),
(NULL, @en_q43, 'Giza', 0),
(NULL, @en_q43, 'Luxor', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vem höll det berömda talet "I Have a Dream" 1963?', 2, 44);
SET @sv_q44 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q44, 'Martin Luther King Jr.', 1),
(@sv_q44, 'Malcolm X', 0),
(@sv_q44, 'John F. Kennedy', 0),
(@sv_q44, 'Rosa Parks', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'Who delivered the famous "I Have a Dream" speech in 1963?', 2, 44);
SET @en_q44 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q44, 'Martin Luther King Jr.', 1),
(NULL, @en_q44, 'Malcolm X', 0),
(NULL, @en_q44, 'John F. Kennedy', 0),
(NULL, @en_q44, 'Rosa Parks', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vem var den första människan som gick på månen?', 2, 45);
SET @sv_q45 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q45, 'Neil Armstrong', 1),
(@sv_q45, 'Buzz Aldrin', 0),
(@sv_q45, 'Yuri Gagarin', 0),
(@sv_q45, 'Michael Collins', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'Who was the first human to walk on the moon?', 2, 45);
SET @en_q45 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q45, 'Neil Armstrong', 1),
(NULL, @en_q45, 'Buzz Aldrin', 0),
(NULL, @en_q45, 'Yuri Gagarin', 0),
(NULL, @en_q45, 'Michael Collins', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vilken stad är Portugals huvudstad?', 2, 46);
SET @sv_q46 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q46, 'Lissabon', 1),
(@sv_q46, 'Porto', 0),
(@sv_q46, 'Madrid', 0),
(@sv_q46, 'Faro', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'Which city is the capital of Portugal?', 2, 46);
SET @en_q46 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q46, 'Lisbon', 1),
(NULL, @en_q46, 'Porto', 0),
(NULL, @en_q46, 'Madrid', 0),
(NULL, @en_q46, 'Faro', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vilket grundämne har det kemiska tecknet Na?', 2, 47);
SET @sv_q47 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q47, 'Natrium', 1),
(@sv_q47, 'Nickel', 0),
(@sv_q47, 'Neon', 0),
(@sv_q47, 'Kväve', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'Which element has the chemical symbol Na?', 2, 47);
SET @en_q47 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q47, 'Sodium', 1),
(NULL, @en_q47, 'Nickel', 0),
(NULL, @en_q47, 'Neon', 0),
(NULL, @en_q47, 'Nitrogen', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vem skrev pjäsen "Romeo och Julia"?', 2, 48);
SET @sv_q48 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q48, 'William Shakespeare', 1),
(@sv_q48, 'Christopher Marlowe', 0),
(@sv_q48, 'Ben Jonson', 0),
(@sv_q48, 'John Milton', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'Who wrote the play "Romeo and Juliet"?', 2, 48);
SET @en_q48 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q48, 'William Shakespeare', 1),
(NULL, @en_q48, 'Christopher Marlowe', 0),
(NULL, @en_q48, 'Ben Jonson', 0),
(NULL, @en_q48, 'John Milton', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Vilket är världens till ytan minsta land?', 2, 49);
SET @sv_q49 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q49, 'Vatikanstaten', 1),
(@sv_q49, 'Monaco', 0),
(@sv_q49, 'San Marino', 0),
(@sv_q49, 'Liechtenstein', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'What is the smallest country in the world by land area?', 2, 49);
SET @en_q49 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q49, 'Vatican City', 1),
(NULL, @en_q49, 'Monaco', 0),
(NULL, @en_q49, 'San Marino', 0),
(NULL, @en_q49, 'Liechtenstein', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('sv', NULL, 'Hur långt är ett maratonlopp?', 2, 50);
SET @sv_q50 = LAST_INSERT_ID();

INSERT INTO answers (question_id, answer_text, is_correct) VALUES
(@sv_q50, '42 195 meter', 1),
(@sv_q50, '40 000 meter', 0),
(@sv_q50, '45 500 meter', 0),
(@sv_q50, '21 097 meter', 0);

INSERT INTO questions (language, category_id, text, difficulty, shared_question_id)
VALUES ('en', NULL, 'How long is a marathon race?', 2, 50);
SET @en_q50 = LAST_INSERT_ID();

INSERT INTO answers VALUES
(NULL, @en_q50, '42,195 meters', 1),
(NULL, @en_q50, '40,000 meters', 0),
(NULL, @en_q50, '45,500 meters', 0),
(NULL, @en_q50, '21,097 meters', 0);