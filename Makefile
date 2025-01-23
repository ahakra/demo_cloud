# Variables
APP_NAME := demo_cloud
COMMIT_HASH ?= $(shell git rev-parse --short HEAD)
BUILD_DIR := ./bin/demo_cloud
GO_FILES := ./cmd/api


.PHONY: build
build:
	echo "Building the project..."
	go  build -ldflags "-X main.version=$(COMMIT_HASH)" -o $(BUILD_DIR) $(GO_FILES)

PHONY: run
run:
	echo "Running the project..."
	go run cmd/api/*

PHONY: fmt vet lint
fmt:
	gofmt -w .
vet:
	go vet ./...
lint: fmt vet
	golangci-lint run

PHONY: test
test:
	go test -v $(GO_FILES)


