# Copyright (C) 2025 Tycho Softworks.
# This code is licensed under MIT license.

.PHONY:	clean upgrade restore deps licenses version tag

clean:
	@dotnet clean

upgrade:
	@dotnet outdated --upgrade
	@dotnet restore

restore:
	@dotnet restore

deps:
	@dotnet list package

licenses:
	@dotnet-project-licenses --input $(ARCHIVE).csproj --include-transitive

version:
	@echo $(VERSION)

tag:	publish
	@.make/publish.sh $(ORIGIN)
	@git tag v$(VERSION)
	@echo "release $(VERSION) packaged and tagged"

