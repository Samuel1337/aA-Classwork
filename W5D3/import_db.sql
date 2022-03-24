PRAGMA foreign_keys = ON;
CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL
);

CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY(user_id) REFERENCES users(id)
);
--WHICH USER FOLLOWS WHICH QUESTION
CREATE TABLE question_follows (
    id INTEGER PRIMARY KEY,
    follower_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY (follower_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);
--
CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    replier_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,
    parent_reply INTEGER,
    body TEXT NOT NULL,


    FOREIGN KEY (replier_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (parent_reply) REFERENCES replies(id)
);

CREATE TABLE question_likes (
    id INTEGER PRIMARY KEY,
    liker_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY (liker_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
    users (fname,lname)
VALUES
    ('Sam','Martins'),
    ('Chin','Edgar'),
    ('Hae Won','Park'),
    ('El','Chavez'),
    ('Taylor','Musolf');

INSERT INTO
    questions (title,body,user_id)
VALUES
    ('Who''s Chucky Woody?',
    'I''ve always wondered about this mysterious person in our cohort.',
    (SELECT id FROM users WHERE fname = 'Sam')),
    
    ('Who''s Cole?',
    'I don''t know.',
    (SELECT id FROM users WHERE fname = 'Sam')),

    ('Who'' reasdf?',
    'Full stack bitch.',
    (SELECT id FROM users WHERE fname = 'Taylor')),

    ('Who'' ready to sagd?',
    'Full stack bitch.',
    (SELECT id FROM users WHERE fname = 'Hae Won')),

    ('Who'' reawefaw?',
    'Full stack bitch.',
    (SELECT id FROM users WHERE fname = 'Hae Won')),
    
    ('Who'' rgsadfas?',
    'Full stack bitch.',
    (SELECT id FROM users WHERE fname = 'Taylor'));

INSERT INTO 
    question_follows (follower_id, question_id)
VALUES 
    ((SELECT id FROM users WHERE fname = 'Hae Won'),
    (SELECT id FROM questions WHERE title = 'Who'' reasdf?')),

    ((SELECT id FROM users WHERE fname = 'Hae Won'),
    (SELECT id FROM questions WHERE title = 'Who''s Cole?')),

    ((SELECT id FROM users WHERE fname = 'Sam'),
    (SELECT id FROM questions WHERE title = 'Who''s Cole?')),

    ((SELECT id FROM users WHERE fname = 'Taylor'),
    (SELECT id FROM questions WHERE title = 'Who''s Chucky Woody?'));

INSERT INTO
    replies (replier_id,question_id,parent_reply, body)
VALUES
    ((SELECT id FROM users WHERE fname = 'El'),
    (SELECT id FROM questions WHERE title = 'Who''s Chucky Woody?'),
    NULL,
    'I think he is Keenan but I''m not sure.');
    
INSERT INTO
    replies (replier_id,question_id,parent_reply, body)
VALUES
    ((SELECT id FROM users WHERE fname = 'Taylor'),
    (SELECT id FROM questions WHERE title = 'Who''s Chucky Woody?'),
    (SELECT id FROM replies WHERE body = 'I think he is Keenan but I''m not sure.'),
    'Alrighty everyone time for flex time!!'),

    ((SELECT id FROM users WHERE fname = 'Chin'),
    (SELECT id FROM questions WHERE title = 'Who''s Cole?'),
    NULL,
    'I heard he''s good at smash bros.');

INSERT INTO
    question_likes (liker_id,question_id)
VALUES
    ((SELECT id FROM users WHERE fname = 'El'),
    (SELECT id FROM questions WHERE title = 'Who''s Chucky Woody?')),

    ((SELECT id FROM users WHERE fname = 'Taylor'),
    (SELECT id FROM questions WHERE title = 'Who''s Chucky Woody?')),
    ((SELECT id FROM users WHERE fname = 'Taylor'),
    (SELECT id FROM questions WHERE title = 'Who'' reasdf?')),
    ((SELECT id FROM users WHERE fname = 'Taylor'),
    (SELECT id FROM questions WHERE title = 'Who'' reasdf?')),
    ((SELECT id FROM users WHERE fname = 'Taylor'),
    (SELECT id FROM questions WHERE title = 'Who'' reawefaw?')),
    
    ((SELECT id FROM users WHERE fname = 'Sam'),
    (SELECT id FROM questions WHERE title = 'Who''s Cole?'));





