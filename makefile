default:	
	@dub build --build=debug
	@emacs --debug-init


rebuild:
	dub build --build=debug