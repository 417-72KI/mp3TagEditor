.SILENT:

PRODUCT_NAME := mp3TagEditor
DERIVED_DATA_PATH := build

run: build
	open ${DERIVED_DATA_PATH}/Build/Products/Debug/${PRODUCT_NAME}.app

setup:
	mint bootstrap

build:
	xcrun xcodebuild \
		-resolvePackageDependencies \
		-project 'mp3TagEditor.xcodeproj' \
		-scheme 'mp3TagEditor' \
	xcrun xcodebuild \
		-project 'mp3TagEditor.xcodeproj' \
		-scheme 'mp3TagEditor' \
		-configuration Debug \
		-destination 'platform=macOS' \
		-derivedDataPath ${DERIVED_DATA_PATH} \
		| xcbeautify

clean:
	xcrun xcodebuild \
		-project 'mp3TagEditor.xcodeproj' \
		-scheme 'mp3TagEditor' \
		-configuration Debug \
		-clonedSourcePackagesDirPath .build \
		clean | xcbeautify

test:
	xcrun xcodebuild \
		-project 'mp3TagEditor.xcodeproj' \
		-scheme 'mp3TagEditor' \
		-configuration Debug \
		-destination 'platform=macOS' \
		test | xcbeautify
