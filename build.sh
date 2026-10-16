#!/bin/bash
# Build Keyboard Lock.app — jalankan di folder yang sama dengan KeyboardLock.swift
set -e

APP="Keyboard Lock.app"
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS"

swiftc -O KeyboardLock.swift -o "$APP/Contents/MacOS/KeyboardLock" -framework Cocoa

cat > "$APP/Contents/Info.plist" <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleName</key><string>Keyboard Lock</string>
    <key>CFBundleIdentifier</key><string>id.farid.keyboardlock</string>
    <key>CFBundleExecutable</key><string>KeyboardLock</string>
    <key>CFBundlePackageType</key><string>APPL</string>
    <key>CFBundleVersion</key><string>1.0</string>
    <key>CFBundleShortVersionString</key><string>1.0</string>
    <key>LSMinimumSystemVersion</key><string>11.0</string>
    <key>NSHighResolutionCapable</key><true/>
</dict>
</plist>
EOF

codesign --force --deep --sign - "$APP"
echo "Selesai: $APP"
echo "Pindahkan ke /Applications lalu buka."
