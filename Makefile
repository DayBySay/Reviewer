build:
	swift build

release:
	swift build --disable-sandbox -c release

install : release
	cp -f .build/release/Reviewer /usr/local/bin/reviewer

uninstall:
	rm /usr/local/bin/reviewer

project:
	swift package generate-xcodeproj
