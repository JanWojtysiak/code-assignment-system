-- ===== SŁOWNIKI =====

CREATE TABLE programming_language (
    id   SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE grade_value (
    id    SERIAL PRIMARY KEY,
    value DECIMAL(2,1) NOT NULL UNIQUE CHECK (value BETWEEN 2.0 AND 5.0),
    name  TEXT NOT NULL UNIQUE
);


-- ===== OSOBY =====

--  (tabela nadrzędna dla ról) --

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


CREATE TABLE student (
    id SERIAL PRIMARY KEY,
    person_id INTEGER NOT NULL UNIQUE REFERENCES person(id)
);
-- ===== KURSY =====

CREATE TABLE course (
    id          SERIAL PRIMARY KEY,
    name        TEXT NOT NULL,
    language_id INTEGER NOT NULL REFERENCES programming_language(id)
);

CREATE TABLE classroom (
    id           SERIAL PRIMARY KEY,
    course_id    INTEGER NOT NULL REFERENCES course(id),
    group_number INTEGER NOT NULL,
    UNIQUE (course_id, group_number),
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

CREATE TABLE student_classroom (
    student_id   INTEGER NOT NULL REFERENCES student(id),
    classroom_id INTEGER NOT NULL REFERENCES classroom(id),
    enrolled_at  TIMESTAMP NOT NULL DEFAULT now(),
    PRIMARY KEY (student_id, classroom_id)
);
-- ===== ZADANIA I OCENY =====

CREATE TABLE grade_value (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE grade (
    id             SERIAL PRIMARY KEY,
    student_id     INTEGER NOT NULL,
    classroom_id   INTEGER NOT NULL,
    grade_value_id INTEGER NOT NULL REFERENCES grade_value(id),
    weight         INTEGER NOT NULL CHECK (weight > 0),
    created_at     TIMESTAMP NOT NULL DEFAULT now(),
    FOREIGN KEY (student_id, classroom_id)
        REFERENCES student_classroom(student_id, classroom_id)
);

CREATE TABLE ai_evaluation (
    id INTEGER PRIMARY KEY,
    submission_id INTEGER NOT NULL REFERENCES submission(id),
    model_name TEXT NOT NULL,
    score DECIMAL(5,2) NOT NULL CHECK (score BETWEEN 0 AND 100),
    feedback TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    approved_at TIMESTAMP,
    final_score DECIMAL(5,2) CHECK (final_score BETWEEN 0 AND 100),
    approved_by INTEGER REFERENCES instructor(id)
);
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
    CHECK (
        (approved_by IS NULL AND approved_at IS NULL AND final_score IS NULL)
        OR
        (approved_by IS NOT NULL AND approved_at IS NOT NULL AND final_score IS NOT NULL)
    )
);

CREATE TABLE submission (
    id INTEGER PRIMARY KEY,
    student_id INTEGER NOT NULL REFERENCES student(id),
    assignment_id INTEGER NOT NULL REFERENCES assigment(id),
    submitted_at TIMESTAMP NOT NULL DEFAULT now()
);