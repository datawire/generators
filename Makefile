GENERATORS_DIR := generators
GENERATOR_METADATA_FILE := generator-config.yaml
JSON_OUTPUT := generators.json

REPO := generators
REPO_ORG := datawire
REPO_BRANCH := main
REPO_BASE_URL := https://github.com/$(REPO_ORG)/$(REPO)/raw/$(REPO_BRANCH)


# Setting SHELL to bash allows bash commands to be executed by recipes.
# Options are set to exit when a recipe line exits non-zero or a piped command fails.
SHELL = /usr/bin/env bash -o pipefail
.SHELLFLAGS = -ec

# Default `make` to run `make generate-metadata`
.PHONY: all
all: generate-metadata

.PHONY: generate-metadata
generate-metadata:
	@echo "{" > $(JSON_OUTPUT)
	@echo '  "generators": [' >> $(JSON_OUTPUT)
	@find $(GENERATORS_DIR) -type f -name $(GENERATOR_METADATA_FILE) | while read -r generator_config_file; do \
		gen_dir="$$(basename "$$(dirname "$$generator_config_file")")"; \
		gen_name="$$(yq eval '.metadata.name' "$$generator_config_file")"; \
		gen_description="$$(yq eval '.metadata.description' "$$generator_config_file")"; \
		gen_version="$$(yq eval '.metadata.version' "$$generator_config_file")"; \
		gen_languages="$$(yq eval '.metadata.languages' "$$generator_config_file")"; \
		echo '    {' >> $(JSON_OUTPUT); \
		echo '      "name": "'$$gen_name'",' >> $(JSON_OUTPUT); \
		echo '      "description": "'$$gen_description'",' >> $(JSON_OUTPUT); \
		echo '      "version": "'$$gen_version'",' >> $(JSON_OUTPUT); \
		echo '      "languages": '$$gen_languages',' >> $(JSON_OUTPUT); \
		echo '      "dir_name": "'$$gen_dir'"' >> $(JSON_OUTPUT); \
		echo '    },' >> $(JSON_OUTPUT); \
	done
	@sed -i '$$s/,$$/]/' $(JSON_OUTPUT)
	@echo "}" >> $(JSON_OUTPUT)
