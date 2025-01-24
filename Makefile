# Variables
APP_NAME := demo_cloud
COMMIT_HASH ?= $(shell git rev-parse --short HEAD)
BUILD_DIR := ./bin/demo_cloud
GO_FILES := ./cmd/api
IAC_DIR := ./IAC/gke


.PHONY: build
build:
	echo "Building the project..."
	go  build -ldflags "-X main.version=$(COMMIT_HASH)" -o $(BUILD_DIR) $(GO_FILES)

PHONY: run
run:
	echo "Running the project..."
	go run cmd/api/*

.PHONY: fmt vet lint
fmt:
	gofmt -w .
vet:
	go vet ./...
lint: fmt vet
	golangci-lint run

.PHONY: test
test:
	go test -v $(GO_FILES)

.PHONY: iacup
iacup:
	cd $(IAC_DIR) && gcloud deployment-manager deployments create gke-deployment \
                             --config deployment.yaml

.PHONY: iacdown
iacdown:
	cd $(IAC_DIR) && gcloud deployment-manager deployments delete gke-deployment --quiet

.PHONY: authgcp
authgcp:
	gcloud auth activate-service-account $(KUSER) --key-file=$(KPATH)

.PHONY:setgcpacc
setgcpacc:
	gcloud config set account $(KUSER)

.PHONY: getcred
getcred:
	gcloud container clusters get-credentials gke-cluster --zone us-central1-a


.PHONY: installvault
installvault:
	helm repo add hashicorp https://helm.releases.hashicorp.com
	helm repo update
	helm install vault hashicorp/vault --set='server.ha.enabled=false' --set='server.standalone.enabled=true'
	kubectl get pods

.PHONY: configurevault
configurevalut:
	source ~/.bashrc
	kubectl exec vault-0 -- vault operator init -key-shares=1 -key-threshold=1 -format=json > $(VPATH)
	kubectl exec vault-0 -- vault operator unseal $(VAULT_UNSEAL_KEY)
	kubectl exec vault-0 -- vault login $(CLUSTER_ROOT_TOKEN)
	kubectl exec vault-0 -- vault status



.PHONY: setup-cluster
setup-cluster: iacup authgcp setgcpacc getcred installvault configurevault