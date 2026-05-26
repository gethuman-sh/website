.PHONY: deploy publish build serve diagrams check-hop

diagrams:
	go tool control --diagram diagrams/human-loop.txt --out static/human-loop.svg
	go tool control --diagram diagrams/skills.txt --out static/skills.svg
	go tool control --diagram diagrams/whats-included.txt --out static/whats-included.svg

build: diagrams
	go tool hugo

serve: diagrams
	go tool hugo server

publish: deploy

# hop is a CGO tool that links the system libwebp library, so building it from
# source (via `go tool`) needs a C compiler and the libwebp dev headers.
# Deploy also pulls the CDN key from 1Password, so the `op` CLI must be present.
check-hop:
	@command -v cc >/dev/null 2>&1 || command -v gcc >/dev/null 2>&1 || { \
		echo "hop needs a C compiler (CGO). Install one:"; \
		echo "  Debian/Ubuntu : sudo apt install build-essential"; \
		echo "  Fedora        : sudo dnf install gcc"; \
		echo "  macOS         : xcode-select --install"; \
		exit 1; }
	@pkg-config --exists libwebp 2>/dev/null || test -f /usr/include/webp/encode.h || { \
		echo "hop needs the libwebp development headers (CGO dependency for WebP):"; \
		echo "  Debian/Ubuntu : sudo apt install libwebp-dev"; \
		echo "  Fedora        : sudo dnf install libwebp-devel"; \
		echo "  Arch          : sudo pacman -S libwebp"; \
		echo "  macOS (brew)  : brew install webp"; \
		exit 1; }
	@command -v op >/dev/null 2>&1 || { \
		echo "deploy needs the 1Password CLI 'op' on PATH:"; \
		echo "  https://developer.1password.com/docs/cli/get-started/"; \
		exit 1; }

deploy: build check-hop
	go tool hop cdn push --purge --from=public --zone=gethuman --key=$$(op item get "Bunny API Key" --fields notesPlain)
