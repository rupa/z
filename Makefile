# check if the command manpath exists. Use the first path found as the path
# to copy z.1 to.
$(eval MAN_PATH=$(shell command -v manpath >/dev/null 2>&1 && manpath | \
	cut -d ':' -f1))

# first we copy the man file to a directory in the manpath
# then we copy the z.sh file to the home directory
# then we add '. ~/z.sh' to the .bashrc file to source z.sh
# we then reload the bashrc file
install:
	@cp z.1 $(MAN_PATH)/man1/z.1
	@cp z.sh $(HOME)/z.sh
	@[ -f $(HOME)/.bashrc ] && echo ". ${HOME}/z.sh" >> $(HOME)/.bashrc
	@. $(HOME)/.bashrc
	@echo "Installation completed! cd around for a while to build up the db. \
		PROFIT!!"

# we only need to remove 2 files. We can't remove lines from the .basrc file
# of people because this could do some really bad stuff
uninstall:
	@rm $(MAN_PATH)/man1/z.1
	@rm $(HOME)/z.sh
	@echo "Don't forgot to remove the '. ~/z.sh' line in your .bashrc file"

readme:
	@groff -man -Tascii z.1 | col -bx

.PHONY: readme install uninstall MAN_PATH
