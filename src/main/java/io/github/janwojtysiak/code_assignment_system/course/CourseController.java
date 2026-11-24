package io.github.janwojtysiak.code_assignment_system.course;

import java.net.URI;
import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

@RestController
@RequestMapping("/api/courses")
class CourseController {

    private final CourseService service;

    CourseController(CourseService service) {
        this.service = service;
    }

    record CourseRequest(@NotBlank String name, @NotNull Integer languageId) {}

    @GetMapping
    List<Course> getAll() {
        return service.getAll();
    }

    @GetMapping("/{id}")
    Course getById(@PathVariable int id) {
        return service.getById(id);
    }

    @PostMapping
    ResponseEntity<Course> create(@Valid @RequestBody CourseRequest request) {
        Course course = service.create(request.name().trim(), request.languageId());
        URI location = ServletUriComponentsBuilder.fromCurrentRequest()
                .path("/{id}")
                .buildAndExpand(course.id())
                .toUri();
        return ResponseEntity.created(location).body(course);
    }

    @PutMapping("/{id}")
    Course update(@PathVariable int id, @Valid @RequestBody CourseRequest request) {
        return service.update(id, request.name().trim(), request.languageId());
    }

    @DeleteMapping("/{id}")
    ResponseEntity<Void> delete(@PathVariable int id) {
        service.delete(id);
        return ResponseEntity.noContent().build();
    }
}
