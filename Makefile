.PHONY: fmt build
fmt:
	terraform fmt -diff -check -recursive
build:
	cd app; DOCKER_BUILDKIT=1 docker image build . --tag us-east4-docker.pkg.dev/atyeti-backstage/backstage/app:latest
