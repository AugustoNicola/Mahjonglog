.PHONY: run test docs clean check debug help

# SWI-Prolog executable
SWIPL := swipl

# Project directories
SRC_DIR := src
TEST_DIR := tests
DOCS_DIR := docs

# Main entry point
MAIN := $(SRC_DIR)/mahjong.pl

help:
	@echo "Riichi Mahjong Prolog Project"
	@echo "=============================="
	@echo ""
	@echo "Available targets:"
	@echo "  make run      - Load main module and start REPL"
	@echo "  make test     - Run unit tests"
	@echo "  make docs     - Generate HTML documentation from PlDoc"
	@echo "  make check    - Syntax check all .pl files"
	@echo "  make debug    - Start REPL with debugger enabled"
	@echo "  make clean    - Remove generated files"
	@echo "  make help     - Show this help message"
	@echo ""

run:
	@echo "Loading $(MAIN)..."
	$(SWIPL) $(MAIN)

test:
	@echo "Running tests from $(TEST_DIR)..."
	$(SWIPL) -g "consult('$(TEST_DIR)/tests'), run_tests, halt" -t 'halt(1)'

docs:
	@echo "Generating documentation to $(DOCS_DIR)..."
	@mkdir -p $(DOCS_DIR)
	$(SWIPL) -g "doc_collect(true), make_library_index('$(SRC_DIR)'), halt" -t halt

check:
	@echo "Checking syntax of all .pl files..."
	@for f in $(SRC_DIR)/*.pl $(TEST_DIR)/*.pl; do \
		if [ -f "$$f" ]; then \
			echo "  Checking $$f..."; \
			$(SWIPL) -g "consult('$$f'), halt" -t 'halt(1)' 2>&1 | grep -i error && exit 1 || true; \
		fi; \
	done
	@echo "✓ All syntax checks passed"

debug:
	@echo "Starting REPL with debug tracing..."
	$(SWIPL) -g "trace" $(MAIN)

clean:
	@echo "Cleaning generated files..."
	rm -rf $(DOCS_DIR)/*.html
	rm -rf $(DOCS_DIR)/*.js
	rm -rf __pycache__ .pytest_cache
	find . -name "*.swp" -delete
	find . -name "*~" -delete
	@echo "✓ Cleaned"