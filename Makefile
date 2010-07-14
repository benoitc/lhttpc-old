ERL          ?= erl
ERLC		 ?= erlc
APP          := lhttpc

include vsn.mk

all: doc
	@(./rebar compile)

clean:
	@(./rebar clean)
	@rm -f test/*.beam doc/*.{html,css,png} doc/edoc-info
	@rm -rf cover_report
	@rm -f util/*.beam
	@rm -rf tests_ebin
	

doc: doc/edoc-info

dialyzer:
	@echo Running dialyzer on sources
	@dialyzer --src -r src/

doc/edoc-info:
	@$(ERLC) -o util/ util/make_doc.erl
	@echo Generating documentation from edoc
	@$(ERL) -pa util/ -noinput -s make_doc edoc

test: all
	@$(ERLC) -o util/ util/run_test.erl
	@echo Running tests
	@mkdir -p test_ebin
	@cd test;$(ERL) -make
	@$(ERL) -noshell -pa util/ -pa ebin -pa test_ebin -noinput -s run_test run

release: clean all test dialyzer
	@util/releaser $(APP) $(VSN) 
		
