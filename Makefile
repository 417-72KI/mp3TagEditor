.SILENT:

PRODUCT_NAME := mp3TagEditor
DERIVED_DATA_PATH := build

.PHONY: run
run: build
	open ${DERIVED_DATA_PATH}/Build/Products/Debug/${PRODUCT_NAME}.app

.PHONY: setup
setup:
	mint bootstrap

.PHONY: build
build:
	xcrun xcodebuild \
		-resolvePackageDependencies \
		-project 'mp3TagEditor.xcodeproj' \
		-scheme 'mp3TagEditor'
	xcrun xcodebuild \
		-project 'mp3TagEditor.xcodeproj' \
		-scheme 'mp3TagEditor' \
		-configuration Debug \
		-destination 'platform=macOS' \
		-derivedDataPath ${DERIVED_DATA_PATH} \
		| xcbeautify

.PHONY: clean
clean:
	xcrun xcodebuild \
		-project 'mp3TagEditor.xcodeproj' \
		-scheme 'mp3TagEditor' \
		-configuration Debug \
		-clonedSourcePackagesDirPath .build \
		clean | xcbeautify

.PHONY: test
test:
	xcrun xcodebuild \
		-project 'mp3TagEditor.xcodeproj' \
		-scheme 'mp3TagEditor' \
		-configuration Debug \
		-destination 'platform=macOS' \
		test | xcbeautify
