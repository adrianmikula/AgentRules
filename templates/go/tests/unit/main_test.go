package main

import (
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/go-chi/chi/v5"
	"github.com/stretchr/testify/assert"
)

func TestHomeHandler(t *testing.T) {
	req := httptest.NewRequest("GET", "/", nil)
	w := httptest.NewRecorder()
	HomeHandler(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	assert.Equal(t, "Go Template - Agentic Dev Velocity", w.Body.String())
}

func TestHealthHandler(t *testing.T) {
	req := httptest.NewRequest("GET", "/health", nil)
	w := httptest.NewRecorder()
	HealthHandler(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	assert.Equal(t, "OK", w.Body.String())
}

func TestUsersHandler(t *testing.T) {
	req := httptest.NewRequest("GET", "/api/users", nil)
	w := httptest.NewRecorder()
	UsersHandler(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	assert.Contains(t, w.Header().Get("Content-Type"), "application/json")
	assert.Contains(t, w.Body.String(), "User 1")
	assert.Contains(t, w.Body.String(), "user1@example.com")
}

func TestUserHandler(t *testing.T) {
	r := chi.NewRouter()
	r.Get("/api/users/{id}", UserHandler)
	req := httptest.NewRequest("GET", "/api/users/42", nil)
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	assert.Contains(t, w.Body.String(), "User 42")
	assert.Contains(t, w.Body.String(), "user42@example.com")
}

func TestCountHandler(t *testing.T) {
	req := httptest.NewRequest("GET", "/api/count", nil)
	w := httptest.NewRecorder()
	CountHandler(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	assert.NotEmpty(t, w.Header().Get("X-Count"))
}
