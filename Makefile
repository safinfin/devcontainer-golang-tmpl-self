BINNAME := app-name

.PHONY: prepare
prepare: build-image

.PHONY: build-image
build-image:
	docker build -t mod-name:latest -f docker/Dockerfile .

.PHONY: clean
clean:
	go clean

.PHONY: lint
lint:
	golangci-lint run ./...

.PHONY: lint-cache-clean
lint-cache-clean:
	golangci-lint cache clean

.PHONY: test
test:
	go test -v ./...

.PHONY: test-cache-clean
test-cache-clean:
	go clean -testcache

.PHONY: build
build:
	GOOS=linux GOARCH=amd64 go build -o build/$(BINNAME) main.go
