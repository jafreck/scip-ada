.PHONY: build build-minimal test test-minimal e2e check format clean docker-image docker-test

# Ensure alr is on the PATH
export PATH := $(HOME)/bin:$(PATH)

MINIMAL_BUILD_FLAGS := -- -XENRICH=no
DOCKER_IMAGE ?= scip-ada-dev
DOCKER_PLATFORM ?= linux/amd64
DOCKER_PLATFORM_ARG = $(if $(strip $(DOCKER_PLATFORM)),--platform $(DOCKER_PLATFORM),)
DOCKER_ALIRE_DIR ?= /tmp/alire
DOCKER_TOOLCHAIN := gnat_native=15.2.1 gprbuild=25.0.1

build:
	alr build

build-minimal:
	alr build $(MINIMAL_BUILD_FLAGS)

test: build
	alr exec -- gprbuild -P tests/scip_ada_tests.gpr
	./bin/test_runner

test-minimal:
	alr build $(MINIMAL_BUILD_FLAGS)
	alr exec -- gprbuild -P tests/scip_ada_tests.gpr
	./bin/test_runner

e2e: build
	bash tests/e2e_test.sh

check:
	alr exec -- gnatcheck -P scip_ada.gpr -rules -from=gnatcheck.rules 2>/dev/null || \
		alr exec -- gnatcheck -P scip_ada.gpr || true

format:
	alr exec -- gnatpp -P scip_ada.gpr --pipe || true

clean:
	alr clean
	rm -rf obj/ bin/

docker-image:
	docker buildx build --load $(DOCKER_PLATFORM_ARG) -t $(DOCKER_IMAGE) .

docker-test: docker-image
	docker run --rm $(DOCKER_PLATFORM_ARG) \
		-e HOME=/tmp \
		-e ALIRE_SETTINGS_DIR=$(DOCKER_ALIRE_DIR) \
		-w /workspace \
		$(DOCKER_IMAGE) \
		sh -lc 'mkdir -p "$$ALIRE_SETTINGS_DIR" && alr settings --global --set toolchain.assistant false && alr -n toolchain --disable-assistant --select $(DOCKER_TOOLCHAIN) && alr build && alr exec -- gprbuild -P tests/scip_ada_tests.gpr && alr exec -- ./bin/test_runner'
