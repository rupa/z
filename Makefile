prefix=/usr/local

all:
	cc -Wall -Wextra -pedantic -std=c99 -D_GNU_SOURCE -o _z_prompt_command z_prompt_command.c

install: _z_prompt_command
	install -m 0755 _z_prompt_command $(prefix)/bin

readme:
	@groff -man -Tascii z.1 | col -bx

.PHONY: install readme
