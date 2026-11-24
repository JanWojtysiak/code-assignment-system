package io.github.janwojtysiak.code_assignment_system.error;

import org.springframework.http.HttpStatus;
import org.springframework.web.server.ResponseStatusException;

public final class ApiErrors {

    private ApiErrors() {}

    public static class NotFoundException extends ResponseStatusException {
        public NotFoundException(String message) {
            super(HttpStatus.NOT_FOUND, message);
        }

        public NotFoundException(String resource, Object id) {
            this(resource + " " + id + " not found");
        }
    }

    public static class BadRequestException extends ResponseStatusException {
        public BadRequestException(String message) {
            super(HttpStatus.BAD_REQUEST, message);
        }

        public BadRequestException(String resource, Object id) {
            this(resource + " " + id + " does not exist");
        }
    }

    public static class ConflictException extends ResponseStatusException {
        public ConflictException(String message) {
            super(HttpStatus.CONFLICT, message);
        }

        public ConflictException(String resource, Object id) {
            this(resource + " " + id + " is still in use");
        }
    }
}
