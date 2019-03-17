DOCKER_REGISTRY := docker.dragonfly.co.nz
IMAGE_NAME := $(shell basename `git rev-parse --show-toplevel`)
IMAGE := $(DOCKER_REGISTRY)/$(IMAGE_NAME)
RUN ?= docker run $(DOCKER_ARGS) --rm -v $$(pwd):/work -w /work -u $(UID):$(GID) $(IMAGE)
UID ?= $(shell id -u)
GID ?= $(shell id -g)
DOCKER_ARGS ?= 
GIT_TAG ?= $(shell git log --oneline | head -n1 | awk '{print $$1}')

all: clean notebooks slides

slides: clean differential-privacy.html

NOTEBOOKS := notebooks/dp-practice.Rmd
notebooks: $(NOTEBOOKS:.Rmd=.html)

$(NOTEBOOKS:.Rmd=.html): $(NOTEBOOKS) data/rft-teaching-file.zip data/rft-teaching-file/2011\ Census\ Microdata\ Teaching\ File.csv
	$(RUN) Rscript -e 'rmarkdown::render("$<")'

differential-privacy.html: differential-privacy.Rmd
	$(RUN) Rscript -e 'rmarkdown::render("$<")'

data: data/rft-teaching-file/2011\ Census\ Microdata\ Teaching\ File.csv

data/rft-teaching-file/2011\ Census\ Microdata\ Teaching\ File.csv: data/rft-teaching-file

data/rft-teaching-file: data/rft-teaching-file.zip
	mkdir -p $@
	unzip $< -d data/rft-teaching-file

data/rft-teaching-file.zip:
	wget http://www.ons.gov.uk/ons/rel/census/2011-census/2011-census-teaching-file/rft-teaching-file.zip -P data

listen: 
	$(RUN) ag -l | entr make slides

clean:
	rm -f notebooks/*.html

.PHONY: docker
docker:
	docker build --tag $(IMAGE):$(GIT_TAG) .
	docker tag $(IMAGE):$(GIT_TAG) $(IMAGE):latest

.PHONY: docker-push
docker-push:
	docker push $(IMAGE):$(GIT_TAG)
	docker push $(IMAGE):latest

.PHONY: docker-pull
docker-pull:
	docker pull $(IMAGE):$(GIT_TAG)
	docker tag $(IMAGE):$(GIT_TAG) $(IMAGE):latest

.PHONY: enter
enter: DOCKER_ARGS=-it
enter:
	$(RUN) bash

.PHONY: enter-root
enter-root: DOCKER_ARGS=-it
enter-root: UID=root
enter-root: GID=root
enter-root:
	$(RUN) bash

.PHONY: inspect-variables
inspect-variables:
	@echo DOCKER_REGISTRY: $(DOCKER_REGISTRY)
	@echo IMAGE_NAME:      $(IMAGE_NAME)
	@echo IMAGE:           $(IMAGE)
	@echo RUN:             $(RUN)
	@echo UID:             $(UID)
	@echo GID:             $(GID)
	@echo DOCKER_ARGS:     $(DOCKER_ARGS)
	@echo GIT_TAG:         $(GIT_TAG)
