# Keyboard Lock

A lightweight macOS application to temporarily lock the **keyboard and trackpad**, designed for safely cleaning your MacBook or external keyboard.

## Features

- One click to lock all keyboard input: standard keys, modifier keys, media, brightness, and volume controls.
- Trackpad locking: cursor movement, clicks, scrolling, drags, multi-touch gestures (pinch, swipe, rotate), and force clicks.
- Unlock by holding **Left ⌘ + Right ⌘** simultaneously for **5 seconds**. Features a countdown progress bar; releasing either key resets the countdown.
- Native Swift (AppKit) with zero external dependencies.

## Requirements

- macOS 11 (Big Sur) or later
- Xcode or Xcode Command Line Tools (`xcode-select --install`)

## Build & Install

```bash
git clone https://github.com/<username>/keyboard-lock.git
cd keyboard-lock
bash build.sh
mv "Keyboard Lock.app" /Applications/
open "/Applications/Keyboard Lock.app"
```

## Accessibility Permission

This application requires Accessibility permission to capture and block keyboard and trackpad inputs.

1. Click **Kunci Keyboard & Trackpad** (Lock Keyboard & Trackpad). macOS will prompt you for permission.
2. Open **System Settings › Privacy & Security › Accessibility**, then enable **Keyboard Lock**.
3. Quit the app (⌘Q) and reopen it.

Every time you rebuild the application, its ad-hoc code signature changes, causing macOS to invalidate previously granted permissions. You can reset it using:

```bash
tccutil reset Accessibility id.farid.keyboardlock
```

## How to Use

1. Launch the app and click **Kunci Keyboard & Trackpad**.
2. Clean your keyboard and trackpad safely.
3. Hold **Left ⌘ + Right ⌘** together for 5 seconds to unlock.

> ⚠️ While locked, the trackpad is also disabled, meaning the only way to unlock is by pressing Left ⌘ + Right ⌘ simultaneously. Test this unlock combination before cleaning. In an emergency, press and hold the power button to force shut down your Mac; input lock will reset upon reboot.

## How It Works

The app uses `CGEventTap` at the session level to intercept keyboard events (`keyDown`, `keyUp`, `flagsChanged`, `NX_SYSDEFINED`) as well as mouse, trackpad, and gesture events, suppressing them from reaching the system. The state of Left ⌘ and Right ⌘ is detected via device-specific flags (`0x08` and `0x10`) inside `flagsChanged` events.

> **Note:** Hardware power buttons and Touch ID cannot be intercepted by regular user applications.

## Project Structure

```
KeyboardLock.swift   # Application source code
build.sh             # Script to build .app bundle & apply ad-hoc codesign
```

## License

MIT
