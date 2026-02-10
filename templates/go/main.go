package main

import (
	"encoding/json"
	"net/http"
	"strconv"
	"sync/atomic"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/cors"
)

// Counter tracks the request count atomically
type Counter struct {
	value int64
}

// User represents a user in the system
type User struct {
	ID    int64  `json:"id"`
	Name  string `json:"name"`
	Email string `json:"email"`
}

var counter = &Counter{}

func main() {
	r := chi.NewRouter()

	// CORS middleware
	cors := cors.New(cors.Options{
		AllowedOrigins:   []string{"*"},
		AllowedMethods:   []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
		AllowedHeaders:   []string{"Accept", "Authorization", "Content-Type", "X-CSRF-Token"},
		ExposedHeaders:   []string{"X-Count"},
		AllowCredentials: true,
		MaxAge:           300,
	})
	r.Use(cors.Handler)

	// Routes
	r.Get("/", HomeHandler)
	r.Get("/health", HealthHandler)
	r.Get("/api/count", CountHandler)
	r.Get("/api/users", UsersHandler)
	r.Get("/api/users/{id}", UserHandler)

	// Atomic increment for count
	r.Use(func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			atomic.AddInt64(&counter.value, 1)
			next.ServeHTTP(w, r)
		})
	})

	println("Server starting on :8080")
	if err := http.ListenAndServe(":8080", r); err != nil {
		panic(err)
	}
}

func HomeHandler(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("Go Template - Agentic Dev Velocity"))
}

func HealthHandler(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("OK"))
}

func CountHandler(w http.ResponseWriter, r *http.Request) {
	count := atomic.LoadInt64(&counter.value)
	w.Header().Set("X-Count", strconv.FormatInt(count, 10))
	w.Write([]byte(strconv.FormatInt(count, 10)))
}

func UsersHandler(w http.ResponseWriter, r *http.Request) {
	users := []User{
		{ID: 1, Name: "User 1", Email: "user1@example.com"},
		{ID: 2, Name: "User 2", Email: "user2@example.com"},
		{ID: 3, Name: "User 3", Email: "user3@example.com"},
	}
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(users)
}

func UserHandler(w http.ResponseWriter, r *http.Request) {
	id := chi.URLParam(r, "id")
	idInt, _ := strconv.ParseInt(id, 10, 64)
	user := User{
		ID:    idInt,
		Name:  "User " + id,
		Email: "user" + id + "@example.com",
	}
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(user)
}
