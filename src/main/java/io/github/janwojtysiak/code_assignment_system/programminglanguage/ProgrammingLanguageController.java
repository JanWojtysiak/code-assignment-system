package io.github.janwojtysiak.code_assignment_system.programminglanguage;
import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/programming-languages")
class ProgrammingLanguageController {

    private final ProgrammingLanguageService service;

    ProgrammingLanguageController(ProgrammingLanguageService service) {
        this.service = service;
    }

    @GetMapping
    List<ProgrammingLanguage> getAll() {
        return service.getAll();
    }
}
