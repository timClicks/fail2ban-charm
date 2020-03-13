PYTHON := /usr/bin/env python

clean:
	find . -name \*.pyc -delete
	find . -name '*.bak' -delete

lint:
	@flake8 --exclude hooks/charmhelpers --ignore=E125 hooks
	charm proof

deploy:
	@echo Deploying ubuntu charm
	juju deploy cs:trusty/ubuntu
	@echo Deploying local fail2ban charm
	juju deploy --repository=../.. local:trusty/fail2ban
	juju add-relation ubuntu:juju-info fail2ban:juju-info

# The following targets are used for charm maintenance only.
bin/charm_helpers_sync.py:
	@mkdir -p bin
	bzr cat lp:charm-helpers/tools/charm_helpers_sync/charm_helpers_sync.py \
		> bin/charm_helpers_sync.py

sync: bin/charm_helpers_sync.py
	@$(PYTHON) bin/charm_helpers_sync.py -c charm-helpers.yaml
