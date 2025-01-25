package main

import (
	"fmt"
	"net/http"
	"os"
)

func (app *application) healthcheckHandler(w http.ResponseWriter, r *http.Request) {

	value := os.Getenv("MY_SECRET_KEY")
	if value == "" {
		app.logger.Info("empty secret key")
	} else {
		fmt.Println("MY_SECRET_KEY:", value)
	}

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
