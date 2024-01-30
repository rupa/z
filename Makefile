readme:
	@groff -man -Tascii u.1 | col -bx

.PHONY: readme
