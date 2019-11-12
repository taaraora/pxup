
define CONFIG_INIT
	@echo "Initializing config..."
	if [ ! -f global_vars.yml ]; \
	then \
		cp "global_vars.yml.sample" "global_vars.yml"; \
	fi
endef

.PHONY: default
default: help

.PHONY: bootstrap
# @HELP Installs needed dependencies vagrant+libvirt tandem
bootstrap:
	./bootstrap.sh

.PHONY: update
# @HELP just starts ansible provisioner
update:
	./update.sh

.PHONY: config-init
# @HELP Installs config file from sample
config-init:
	@$(call CONFIG_INIT)

.PHONY: up
# @HELP invokes vangrant up using parameters from global_vars.yml
up:
ifeq (,$(wildcard ./global_vars.yml))
	$(error config file global_vars.yml does not exist, please issue make config-init to generate config file)
endif
	./up.sh

.PHONY: down
# @HELP invokes vangrant destroy
down:
	./down.sh

.PHONY: help
# @HELP Prints help
help:
	@sed -ne"/^# @HELP /{h;s/.*//;:d" -e"H;n;s/^# @HELP //;td" -e"s/:.*//;G;s/\\n# @HELP /---/;s/\\n/ /g;p;}" ${MAKEFILE_LIST}|LC_ALL='C' sort -f|awk -F --- -v n=$$(tput cols) -v i=19 -v a="$$(tput setaf 6)" -v z="$$(tput sgr0)" '{printf" %s%*s%s ",a,-i,$$1,z;m=split($$2,w," ");l=n-i;for(j=1;j<=m;j++){l-=length(w[j])+1;if(l<= 0){l=n-i-length(w[j])-1;printf"\n%*s ",-i," ";}printf"%s ",w[j];}printf"\n";}'
