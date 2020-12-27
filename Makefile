.SILENT:

PRODUCT_NAME := mp3TagEditor

run: build
	open build/Debug/${PRODUCT_NAME}.app

setup:
	mint bootstrap
	mint run xcodegen xcodegen generate --use-cache --quiet

xcproj-quiet:
	mint run xcodegen xcodegen generate --use-cache --quiet

build: xcproj-quiet
	xcrun xcodebuild -configuration Debug build | xcpretty
