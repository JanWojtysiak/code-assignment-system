package io.github.janwojtysiak.code_assignment_system.programminglanguage;
import java.util.List;
import org.springframework.jdbc.core.simple.JdbcClient;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
@Service
@Transactional(readOnly = true)
class ProgrammingLanguageService {

    private final JdbcClient jdbc;

    ProgrammingLanguageService(JdbcClient jdbc) {
        this.jdbc = jdbc;
    }

    List<ProgrammingLanguage> getAll() {
        return jdbc.sql("SELECT id, name FROM programming_language ORDER BY name")
                .query(ProgrammingLanguage.class)
                .list();
    }
}