.ONESHELL:
SHELL := /bin/bash
.PHONY: help init validate build

now := $(shell date +"%s")

AWS_LOGIN=$(STS_USER)

set-env:
	@packer version | grep "Packer v1\.1\.[0-9]*" >/dev/null; case $$? in \
		1) echo You need Packer version 1.1.x!; exit 1;; \
	esac

init: set-env
	@echo "Initializing the terraform environment"
    ifeq ($(AWS_LOGIN), )
	    echo "Some important inputs are missing. [Set your AWS user <STS_USER> to environment and execute sts-get-session-token <MFA_token>]"
    endif

validate:
	@packer validate $(CURRENT_DIR)/centos7_master_image.json

plan:
	@terraform plan -detailed-exitcode -out=.terraform/$(now).tfplan || \
		( case $$? in \
			0) \
				echo "Succeeded, diff is empty (no changes)" ;; \
			1) \
				echo "Errored" ; \
				false ;; \
			2) \
				echo "Succeeded, there is a diff" ; \
				echo "Use make apply to apply the changes." ;; \
			esac \
		)

apply:
	@echo ""
	@read -p "Apply plan? (y/n) " choice; \
	case "$$choice" in \
		y|Y ) terraform apply .terraform/$(now).tfplan;; \
		* ) echo "Aborting.";; \
	esac

help:
	@echo "Usage: make plan"
