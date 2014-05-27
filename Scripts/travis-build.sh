#!/bin/sh
set -e

cd MFDynamic

pod install

xctool -workspace MFDynamic.xcworkspace -scheme MFDynamic.iOS test
xctool -workspace MFDynamic.xcworkspace -scheme MFDynamic.Mac test