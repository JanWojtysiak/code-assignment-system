-- ===== SŁOWNIKI =====

CREATE TABLE programming_language (
    id   SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

-- ===== OSOBY =====

CREATE TABLE person (
    id         SERIAL PRIMARY KEY,
    name       TEXT NOT NULL,
    surname    TEXT NOT NULL,
    email      TEXT NOT NULL,
    password   TEXT NOT NULL,
    github     TEXT UNIQUE,
    deleted_at TIMESTAMP
);

CREATE TABLE administrator (
    id        SERIAL PRIMARY KEY,
    person_id INTEGER NOT NULL UNIQUE REFERENCES person(id)
);

CREATE TABLE instructor (
    id        SERIAL PRIMARY KEY,
    person_id INTEGER NOT NULL UNIQUE REFERENCES person(id)
);

-- ===== KURSY =====

CREATE TABLE course (
    id          SERIAL PRIMARY KEY,
    name        TEXT NOT NULL,
    language_id INTEGER NOT NULL REFERENCES programming_language(id)
);

CREATE TABLE classroom (
    id        SERIAL PRIMARY KEY,
    course_id INTEGER NOT NULL REFERENCES course(id),
    number    INTEGER NOT NULL,
    UNIQUE (course_id, number),
    UNIQUE (id, course_id)
);


-- ===== INSTRUKTORZY =====

CREATE TABLE instructor_course (
    instructor_id INTEGER NOT NULL REFERENCES instructor(id),
    course_id     INTEGER NOT NULL REFERENCES course(id),
    PRIMARY KEY (instructor_id, course_id)
);

CREATE TABLE instructor_classroom (
    instructor_id INTEGER NOT NULL,
    classroom_id  INTEGER NOT NULL,
    course_id     INTEGER NOT NULL,
    PRIMARY KEY (instructor_id, classroom_id),
    FOREIGN KEY (instructor_id, course_id)
        REFERENCES instructor_course(instructor_id, course_id),
    FOREIGN KEY (classroom_id, course_id)
        REFERENCES classroom(id, course_id)
);

-- ===== STUDENCI =====

CREATE TABLE student (
    id SERIAL PRIMARY KEY,
    person_id INTEGER NOT NULL UNIQUE REFERENCES person(id),
);

CREATE TABLE student_classroom (
    student_id   INTEGER NOT NULL REFERENCES student(id),
    classroom_id INTEGER NOT NULL REFERENCES classroom(id),
    enrolled_at  TIMESTAMP NOT NULL DEFAULT now(),
    PRIMARY KEY (student_id, classroom_id)
);
-- ===== ZADANIA I OCENY =====

CREATE TABLE assignment (
    id            SERIAL PRIMARY KEY,
    classroom_id  INTEGER NOT NULL,
    instructor_id INTEGER NOT NULL,
    title         TEXT NOT NULL,
    description   TEXT NOT NULL,
    deadline      TIMESTAMP NOT NULL,
    created_at    TIMESTAMP NOT NULL DEFAULT now(),
    FOREIGN KEY (instructor_id, classroom_id)
        REFERENCES instructor_classroom(instructor_id, classroom_id)
);
