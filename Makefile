# Copyright (C) 2024 Tycho Softworks.
#
# This file is free software; as a special exception the author gives
# unlimited permission to copy and/or distribute it, with or without
# modifications, as long as this notice is preserved.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY, to the extent permitted by law; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

# Project constants
PROJECT := Tychosoft.Hashing
ARCHIVE := sharperhash
VERSION := 0.0.1
DOTNET	:= net8.0
ORIGIN	:= :tychosoft/$(ARCHIVE)
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

