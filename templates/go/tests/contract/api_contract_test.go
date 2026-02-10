package main

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/go-chi/chi/v5"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

// Contract tests ensure API compatibility

func TestUserSchemaContract(t *testing.T) {
	users := []User{
		{ID: 1, Name: "Test User", Email: "test@example.com"},
	}

	data, err := json.Marshal(users)
	require.NoError(t, err)

	var decoded []User
	err = json.Unmarshal(data, &decoded)
	require.NoError(t, err)

	require.Len(t, decoded, 1)
	assert.Equal(t, int64(1), decoded[0].ID)
	assert.Equal(t, "Test User", decoded[0].Name)
	assert.Equal(t, "test@example.com", decoded[0].Email)
}

func TestAPIEndpointsContract(t *testing.T) {
	r := chi.NewRouter()
	r.Get("/", HomeHandler)
	r.Get("/health", HealthHandler)
	r.Get("/api/users", UsersHandler)

	t.Run("root returns expected text", func(t *testing.T) {
		req := httptest.NewRequest("GET", "/", nil)
		w := httptest.NewRecorder()
		r.ServeHTTP(w, req)
		assert.Equal(t, http.StatusOK, w.Code)
		assert.Equal(t, "Go Template - Agentic Dev Velocity", w.Body.String())
	})

	t.Run("health returns OK", func(t *testing.T) {
		req := httptest.NewRequest("GET", "/health", nil)
		w := httptest.NewRecorder()
		r.ServeHTTP(w, req)
		assert.Equal(t, http.StatusOK, w.Code)
		assert.Equal(t, "OK", w.Body.String())
	})

	t.Run("users returns JSON array", func(t *testing.T) {
		req := httptest.NewRequest("GET", "/api/users", nil)
		w := httptest.NewRecorder()
		r.ServeHTTP(w, req)
		assert.Equal(t, http.StatusOK, w.Code)
		assert.Contains(t, w.Header().Get("Content-Type"), "application/json")

		var users []User
		err := json.Unmarshal(w.Body.Bytes(), &users)
		require.NoError(t, err)
		assert.GreaterOrEqual(t, len(users), 3)
	})
}

func TestUserFieldsRequired(t *testing.T) {
	user := User{
		ID:    1,
		Name:  "Test",
		Email: "test@test.com",
	}

	data, err := json.Marshal(user)
	require.NoError(t, err)

	// Verify all fields are present in JSON
	var jsonMap map[string]interface{}
	err = json.Unmarshal(data, &jsonMap)
	require.NoError(t, err)

	assert.Contains(t, jsonMap, "id")
	assert.Contains(t, jsonMap, "name")
	assert.Contains(t, jsonMap, "email")
}
