default: main

main: bin/Dota2Bindings.native
	echo $(wildcard src/*.ml)

run: main
	bin/Dota2Bindings.native

clean:
	ocamlbuild -clean
	rm -rf bin

.PHONY: default main run clean

_build/src/Dota2Bindings.native: $(wildcard src/*.ml)
	ocamlbuild -use-ocamlfind -pkgs lablgtk2 src/Dota2Bindings.native

bin:
	mkdir bin

bin/Dota2Bindings.native: _build/src/Dota2Bindings.native bin
	cp _build/src/Dota2Bindings.native bin/Dota2Bindings.native

