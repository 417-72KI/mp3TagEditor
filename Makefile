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
	xcrun xcodebuild -resolvePackageDependencies -project 'mp3TagEditor.xcodeproj' -scheme 'mp3TagEditor' -clonedSourcePackagesDirPath .build
	xcrun xcodebuild -project 'mp3TagEditor.xcodeproj' -scheme 'mp3TagEditor' -configuration Debug -destination 'platform=macOS,arch=x86_64' -clonedSourcePackagesDirPath .build build | xcpretty

clean: xcproj
	xcrun xcodebuild -configuration Debug clean | xcpretty
