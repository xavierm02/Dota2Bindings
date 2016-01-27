STATIC_ML_FILES=$(wildcard src/*.ml)
ENUM_FILES=$(wildcard src-build/*.enum.type)
COPIED_ML_FILES=$(patsubst src/%.ml,src-generated/%.ml,$(STATIC_ML_FILES))
GENERATED_ML_FILES=$(patsubst src-build/%.enum.type,src-generated/%.ml,$(ENUM_FILES))
ML_FILES=$(COPIED_ML_FILES) $(GENERATED_ML_FILES)
OB=ocamlbuild -use-ocamlfind -build-dir build

default: main

main: bin/Dota2Bindings.native

run: main
	bin/Dota2Bindings.native

clean:
	$(OB) -clean
	rm -rf bin build src-generated

.PHONY: default main run clean

build:
	mkdir -p build

build/src-build/EnumGenerator.native: src-build/EnumGenerator.ml
	$(OB) src-build/EnumGenerator.native

src-generated:
	mkdir -p src-generated

src-generated/%.ml: src-generated build/src-build/EnumGenerator.native src-build/%.enum.ml src-build/%.enum.type
	cat src-build/$*.enum.type | build/src-build/EnumGenerator.native > src-generated/$*.ml
	cat src-build/$*.enum.ml >> src-generated/$*.ml

src-generated/%: src-generated src/%
	cp src/$* src-generated/$*

build/src-generated/Dota2Bindings.native: $(ML_FILES)
	$(OB) -pkgs lablgtk2 src-generated/Dota2Bindings.native

bin:
	mkdir -p bin

bin/Dota2Bindings.native: build/src-generated/Dota2Bindings.native bin
	cp build/src-generated/Dota2Bindings.native bin/Dota2Bindings.native

