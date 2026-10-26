# The operator exports TF_VAR_* variables before running make gen.
.PHONY: gen check

gen:
	python3 scripts/render_infra.py

check:
	python3 scripts/check_invariants.py
