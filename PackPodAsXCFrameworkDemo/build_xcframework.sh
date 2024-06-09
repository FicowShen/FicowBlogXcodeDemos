#!/bin/bash

WORKSPACE_NAME="PackPodAsXCFrameworkDemo.xcworkspace"
SCHEME_NAME="FicowPod"
FRAMEWROK_NAME="FicowPod"

# Cleanup
rm -rf build

# Fetch dependencies
pod install

if [ $? -ne 0 ]; then
    echo "pod install failed. Exiting..."
    exit 1
fi

# Build for iOS Device
xcodebuild archive \
  -workspace $WORKSPACE_NAME \
  -scheme $SCHEME_NAME \
  -destination "generic/platform=iOS Simulator" \
  -configuration Release only_active_arch=no \
  -sdk iphoneos \
  -archivePath build/ios_devices.xcarchive \
  SKIP_INSTALL=NO \
  BUILD_LIBRARIES_FOR_DISTRIBUTION=YES \
  OTHER_SWIFT_FLAGS="-Xfrontend -module-interface-preserve-types-as-written"

if [ $? -ne 0 ]; then
    echo "Build for iOS Device failed. Exiting..."
    exit 1
fi

# Build for iOS Simulator
xcodebuild archive \
  -workspace $WORKSPACE_NAME \
  -scheme $SCHEME_NAME \
  -destination "generic/platform=iOS" \
  -configuration Release only_active_arch=no \
  -sdk iphonesimulator \
  -archivePath build/ios_simulator.xcarchive \
  SKIP_INSTALL=NO \
  BUILD_LIBRARIES_FOR_DISTRIBUTION=YES \
  OTHER_SWIFT_FLAGS="-Xfrontend -module-interface-preserve-types-as-written"


if [ $? -ne 0 ]; then
    echo "Build for iOS Simulator failed. Exiting..."
    exit 1
fi

# Create XCFramework
xcodebuild -create-xcframework \
  -framework build/ios_devices.xcarchive/Products/Library/Frameworks/$FRAMEWROK_NAME.framework \
  -framework build/ios_simulator.xcarchive/Products/Library/Frameworks/$FRAMEWROK_NAME.framework \
  -output build/$FRAMEWROK_NAME.xcframework


if [ $? -ne 0 ]; then
    echo "Create XCFramework failed. Exiting..."
    exit 1
fi
