# --- Configuration ---
IMAGE_NAME = debug-container
DOCKERHUB_USER = azisi
TAG = latest
PLATFORMS = linux/amd64,linux/arm64
BUILDER = multiarch-builder

# --- Targets ---

.PHONY: all build-local run-local buildx-init build-push clean

all: build-local

# Create and bootstrap Buildx builder
buildx-init:
	docker buildx create --name $(BUILDER) --use --driver docker-container || true
	docker buildx inspect --bootstrap

# Build a multi-arch image and push to Docker Hub
build-push: buildx-init
	docker buildx build \
		--platform $(PLATFORMS) \
		-t $(DOCKERHUB_USER)/$(IMAGE_NAME):$(TAG) \
		--push .

# Build a local image for your host architecture
build-local: buildx-init
	docker buildx build \
		--platform linux/amd64 \
		-t $(IMAGE_NAME):local \
		--load .

# Run the locally built debug container
run-local:
	docker run -it --rm $(IMAGE_NAME):local

# Remove local builder and image
clean:
	docker buildx rm $(BUILDER) || true
	docker rmi $(IMAGE_NAME):local || true
