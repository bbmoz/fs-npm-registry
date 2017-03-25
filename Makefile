.DEFAULT_GOAL := start

##################
# Variables
##################

NO_COLOR = \033[0m
OK_COLOR = \033[32;01m
INFO_COLOR = \033[33;01m
WARN_COLOR = \033[31;01m

##################
# Logging
##################

pre-task-msg:
	@printf "\n$(INFO_COLOR)$(name) $(OK_COLOR)[STARTED]$(NO_COLOR)\n\n"

post-task-msg:
	@printf "\n$(INFO_COLOR)$(name) $(OK_COLOR)[FINISHED]$(NO_COLOR)\n\n"

no-program-msg:
	@printf "\n$(INFO_COLOR)$(name) $(WARN_COLOR)[NOT RUNNING]$(NO_COLOR)\n\n"
	exit 1

##################
# Tasks
##################

deps:
	type docker >/dev/null 2>&1 || $(MAKE) no-program-msg name=docker

start: deps
	$(MAKE) pre-task-msg name=$@
	docker pull keyvanfatehi/sinopia
	-docker stop npm-registry
	-docker rm npm-registry
	docker run --name npm-registry -v $$(pwd)/config.yaml:/opt/sinopia/config.yaml -d -p 4000:4000 keyvanfatehi/sinopia
	docker ps
	$(MAKE) post-task-msg name=$@

backup: deps
	$(MAKE) pre-task-msg name=$@
	-rm backup.tar
	docker run --volumes-from npm-registry -v $$(pwd):/backup ubuntu tar cvf /backup/backup.tar /opt/sinopia
	$(MAKE) post-task-msg name=$@

restore: start
	$(MAKE) pre-task-msg name=$@
	docker stop npm-registry
	docker run --volumes-from npm-registry -v $$(pwd):/backup ubuntu tar xvf /backup/backup.tar --exclude config.yaml
	docker start npm-registry
	$(MAKE) post-task-msg name=$@
