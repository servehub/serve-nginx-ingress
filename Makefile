VERSION?=$(shell git describe --tags --abbrev=0 | sed 's/v//')
TAG="servehub/serve-nginx-ingress"

build:
	@echo "==> Build..."
	docker build --platform linux/amd64 -t ${TAG}:latest -t ${TAG}:${VERSION} .

release: build
	@echo "==> Publish new docker image..."
	docker push ${TAG}:${VERSION}
	docker push ${TAG}:latest

bump-tag:
	TAG=$$(echo "v${VERSION}" | awk -F. '{$$NF = $$NF + 1;} 1' | sed 's/ /./g'); \
	git tag $$TAG; \
	git push && git push --tags

