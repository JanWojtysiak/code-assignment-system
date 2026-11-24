package io.github.janwojtysiak.code_assignment_system.course;

import java.util.List;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import io.github.janwojtysiak.code_assignment_system.error.ApiErrors.BadRequestException;
import io.github.janwojtysiak.code_assignment_system.error.ApiErrors.NotFoundException;

@Service
@Transactional(readOnly = true)
class CourseService {

    private final CourseRepository repository;

    CourseService(CourseRepository repository) {
        this.repository = repository;
    }

    List<Course> getAll() {
        return repository.findAll();
    }

    Course getById(int id) {
        return repository.findById(id)
                .orElseThrow(() -> new NotFoundException("Course", id));
    }

    @Transactional
    Course create(String name, int languageId) {
        int id;
        try {
            id = repository.insert(name, languageId);
        } catch (DataIntegrityViolationException e) {
            throw new BadRequestException("Programming language", languageId);
        }
        return getById(id);
    }

    @Transactional
    Course update(int id, String name, int languageId) {
        boolean updated;
        try {
            updated = repository.update(id, name, languageId);
        } catch (DataIntegrityViolationException e) {
            throw new BadRequestException("Programming language", languageId);
        }
        if (!updated) {
            throw new NotFoundException("Course", id);
        }
        return getById(id);
    }

    @Transactional
    void delete(int id) {
        if (!repository.softDeleteById(id)) {
            throw new NotFoundException("Course", id);
        }
    }
}
