VERSION?="1.0.3"
TAG="servehub/serve-nginx-ingress"

release:
	@echo "==> Build and publish new docker image..."
	docker build -t ${TAG}:latest -t ${TAG}:${VERSION} .
	docker push ${TAG}:${VERSION}
	docker push ${TAG}:latest
