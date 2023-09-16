.SILENT:

PRODUCT_NAME := mp3TagEditor
DERIVED_DATA_PATH := build

run: build
	open ${DERIVED_DATA_PATH}/Build/Products/Debug/${PRODUCT_NAME}.app

setup:
	mint bootstrap
	$(MAKE) xcproj

xcproj:
	mint run xcodegen xcodegen generate --use-cache --quiet

build: xcproj
	xcrun xcodebuild \
		-resolvePackageDependencies \
		-project 'mp3TagEditor.xcodeproj' \
		-scheme 'mp3TagEditor' \
		-clonedSourcePackagesDirPath .build
	xcrun xcodebuild \
		-project 'mp3TagEditor.xcodeproj' \
		-scheme 'mp3TagEditor' \
		-configuration Debug \
		-destination 'platform=macOS' \
		-clonedSourcePackagesDirPath .build \
		-derivedDataPath ${DERIVED_DATA_PATH} \
		| xcpretty

clean: xcproj
	xcrun xcodebuild -configuration Debug clean | xcpretty
