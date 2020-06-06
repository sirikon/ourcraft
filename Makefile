.PHONY: build test link install

build:
	@rm -r ./bin
	@shards build --production --release --no-debug

test:
	@crystal spec

link:
	@echo "Linking ourcraft in ./bin/ourcraft to /usr/local/bin/ourcraft"
	@rm -f /usr/local/bin/ourcraft
	@ln -s $(shell pwd)/bin/ourcraft /usr/local/bin/ourcraft

install:
	@echo "Installing ourcraft in /usr/local/bin/ourcraft"
	@rm -f /usr/local/bin/ourcraft
	@cp $(shell pwd)/bin/ourcraft /usr/local/bin/ourcraft

ci: test build
