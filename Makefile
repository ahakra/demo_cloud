.PHONY: build
build:
	echo "Building the project..."
	go build -o ./bin/demo_cloud ./cmd/api

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