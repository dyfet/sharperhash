# Copyright (C) 2025 Tycho Softworks.
# This code is licensed under MIT license.

# Project constants
PROJECT := Tychosoft.Hashing
ARCHIVE := sharperhash
VERSION := 0.0.1
DOTNET	:= net8.0
ORIGIN	:= :dyfet//$(ARCHIVE)
PATH	:= $(PWD)/bin/Debug/$(DOTNET):${PATH}

.PHONY: debug release publish list verify

all:		debug      	# default target debug
verify:		release		# default verification

debug:
	@if test ! -d obj ; then dotnet restore ; fi
	@dotnet build -c Debug

release:
	@dotnet pack -c Release

publish:	release
	@dotnet nuget push bin/Release/$(PROJECT).$(VERSION).nupkg -k $(APIKEY) -s https://api.nuget.org/v3/index.json

list:	release
	@unzip -l bin/Release/$(PROJECT).$(VERSION).nupkg

# Optional make components we may add
sinclude .make/*.mk

