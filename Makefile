.PHONY: fmt
fmt:
	terraform fmt -diff -check -recursive
