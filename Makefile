.SILENT:

PRODUCT_NAME := mp3TagEditor

run: build
	open build/Debug/${PRODUCT_NAME}.app

setup:
	mint bootstrap
	$(MAKE) xcproj

xcproj:
	mint run xcodegen xcodegen generate --use-cache --quiet

build: xcproj
	xcrun xcodebuild -resolvePackageDependencies
	xcrun xcodebuild -project 'mp3TagEditor.xcodeproj' -configuration Debug -destination 'platform=macOS,arch=x86_64' build | xcpretty

clean: xcproj
	xcrun xcodebuild -configuration Debug clean | xcpretty
