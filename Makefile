.PHONY: install uninstall update test clean

install:
	@./install.sh

uninstall:
	@./uninstall.sh

update:
	@./update.sh

test:
	@echo "Running tests..."
	@echo "Checking install script syntax..."
	@bash -n install.sh
	@bash -n uninstall.sh
	@bash -n update.sh
	@echo "Checking hook scripts..."
	@bash -n hooks/pre-tool-use.sh
	@bash -n hooks/post-tool-use.sh
	@bash -n hooks/global/security-check.sh
	@echo "Checking shell aliases..."
	@bash -n shell/aliases.sh
	@echo "All syntax checks passed!"

clean:
	@echo "Cleaning backup files..."
	@rm -rf ~/.claude.backup.*
	@echo "Done"

help:
	@echo "Available targets:"
	@echo "  install   - Install build-my-claude"
	@echo "  uninstall - Remove build-my-claude"
	@echo "  update    - Update to latest version"
	@echo "  test      - Run syntax checks"
	@echo "  clean     - Remove backup files"
