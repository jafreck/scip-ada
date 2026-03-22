.PHONY: build build-minimal test test-minimal e2e check format clean

# Ensure alr is on the PATH
export PATH := $(HOME)/bin:$(PATH)

MINIMAL_BUILD_FLAGS := -- -XENRICH=no

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
