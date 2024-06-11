.PHONY: test format lint

SHELL := /bin/bash
.ONESHELL:

PYENV_ROOT = $(HOME)/.pyenv
PYTHON_VERSION ?= 3.9.16
VENV = .venv
PYTHON = ./$(VENV)/bin/python3
PIP = ./$(VENV)/bin/pip
PRE_COMMIT = ./$(VENV)/bin/pre-commit
DEV?=true

test:
	@$(PYTHON) -m pytest tests

lint:
	@$(PYTHON) -m flake8 sauron_frame_source/*
	@$(PYTHON) -m flake8 --ignore=D,W503,E712 tests/*
	@$(PYTHON) -m mypy sauron_frame_source

format:
	@$(PYTHON) -m black sauron_frame_source/ tests/
	@$(PYTHON) -m isort sauron_frame_source/* tests/*


pyenv:
	@export PYENV_ROOT=$(PYENV_ROOT)
	@bash ./setup_pyenv.sh
	@export PATH=$(PYENV_ROOT)/bin:$(PATH)
	@source ~/.bashrc
	@eval "$(pyenv init -)"
	@pyenv install -s $(PYTHON_VERSION)
	@pyenv global $(PYTHON_VERSION)

venv/bin/activate: pyenv requirements
	@source ~/.bashrc
	@echo "Using $(shell python	 -V)"
	@python3 -m venv $(VENV)
	@chmod +x $(VENV)/bin/activate
	@source ./$(VENV)/bin/activate
	@$(PIP) install -q -r requirements/requirements.txt

venv: venv/bin/activate
	@source ./$(VENV)/bin/activate
	@echo "VIRTUAL ENVIRONMENT LOADED"

install: venv

ifeq ($(DEV), true)
	@$(PIP) install -q -r requirements/requirements_dev.txt
	@echo "DEVELOPMENT DEPENDENCIES INSTALLED"
endif
