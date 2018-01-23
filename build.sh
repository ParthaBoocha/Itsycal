#!/bin/sh

# This script builds Itsycal for distribution.
# It first builds the app and then creates two
# ZIP files and a Sparkle appcast XML file which
# it places on the Desktop. Those files can then
# all be uploaded to the web.

# Get the bundle version from the plist.
PLIST_FILE="Itsycal/Info.plist"
VERSION=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" $PLIST_FILE)

# Set up file names and paths.
BUILD_PATH=$(mktemp -d "$TMPDIR/Itsycal.XXXXXX")
ZIP_NAME="Itsycal-$VERSION.zip"
ZIP_PATH1="$HOME/Desktop/$ZIP_NAME"
ZIP_PATH2="$HOME/Desktop/Itsycal.zip"
XML_PATH="$HOME/Desktop/itsycal.xml"

# Build Itsycal in a temporary build location.
xcodebuild -scheme Itsycal -configuration Release -derivedDataPath "$BUILD_PATH" build

# Go into the temporary build directory.
cd "$BUILD_PATH/Build/Products/Release"

# Compress the app.
rm -f "$ZIP_PATH1"
rm -f "$ZIP_PATH2"
zip -r -y "$ZIP_PATH1" Itsycal.app
cp "$ZIP_PATH1" "$ZIP_PATH2"

# Get the date and zip file size for the Sparkle XML.
DATE=$(TZ=GMT date)
FILESIZE=$(stat -f "%z" "$ZIP_PATH1")
