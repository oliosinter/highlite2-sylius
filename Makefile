# PROJECT VARIABLES
# -----------------------------------------------------------------------------
PROJECT_NAME := highlite2-sylius

# CHECK AND INSPECT LOGIC
# -----------------------------------------------------------------------------
INSPECT := $$(docker-compose -p $$1 -f $$2 ps -q $$3 | xargs -I ARGS docker inspect -f "{{ .State.ExitCode }}" ARGS)

CHECK := @bash -c '\
  if [[ $(INSPECT) -ne 0 ]]; \
  then exit $(INSPECT); fi' VALUE

# INCLUDE CI TARGETS
# -----------------------------------------------------------------------------
include ci/release/Makefile
include ci/prod/Makefile

include dev/Makefile