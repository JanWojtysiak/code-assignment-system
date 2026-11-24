package io.github.janwojtysiak.code_assignment_system.course;

import java.util.List;
import java.util.Optional;

import org.springframework.jdbc.core.simple.JdbcClient;
import org.springframework.stereotype.Repository;

@Repository
class CourseRepository {

    private static final String SELECT_COURSE = """
            SELECT c.id, c.name, c.language_id, pl.name AS language_name
            FROM course c
            JOIN programming_language pl ON pl.id = c.language_id
            WHERE c.deleted_at IS NULL
            """;

    private final JdbcClient jdbc;

    CourseRepository(JdbcClient jdbc) {
        this.jdbc = jdbc;
    }

    List<Course> findAll() {
        return jdbc.sql(SELECT_COURSE + " ORDER BY c.name")
                .query(Course.class)
                .list();
    }

    Optional<Course> findById(int id) {
        return jdbc.sql(SELECT_COURSE + " AND c.id = :id")
                .param("id", id)
                .query(Course.class)
                .optional();
    }

    int insert(String name, int languageId) {
        return jdbc.sql("""
                INSERT INTO course (name, language_id)
                VALUES (:name, :languageId)
                RETURNING id
                """)
                .param("name", name)
                .param("languageId", languageId)
                .query(Integer.class)
                .single();
    }

    boolean update(int id, String name, int languageId) {
        int updated = jdbc.sql("""
                UPDATE course
                SET name = :name, language_id = :languageId
                WHERE id = :id AND deleted_at IS NULL
                """)
                .param("id", id)
                .param("name", name)
                .param("languageId", languageId)
                .update();
        return updated > 0;
    }

    boolean softDeleteById(int id) {
        int deleted = jdbc.sql("""
                UPDATE course
                SET deleted_at = now()
                WHERE id = :id AND deleted_at IS NULL
                """)
                .param("id", id)
                .update();
        return deleted > 0;
    }
}