package main

import (
	"net/http"
	"os"
)

func (app *application) healthcheckHandler(w http.ResponseWriter, r *http.Request) {

	value := os.Getenv("MY_SECRET_KEY")

	res := responseData{
		"Status":      "Available",
		"Envirnoment": app.config.env,
		"version":     Version,
		"Secret":      value,
		"status":      http.StatusText(http.StatusOK),
	}

	err := app.writeJSON(w, http.StatusOK, res, nil)
	if err != nil {
		app.serverSideErrorResponse(w, r, err)
	}
}
