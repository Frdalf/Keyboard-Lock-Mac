# ⌨️ Keyboard Lock for macOS

[![macOS](https://img.shields.io/badge/macOS-11.0%2B-blue?logo=apple&logoColor=white)](https://apple.com)
[![Swift](https://img.shields.io/badge/Swift-5.0%2B-orange?logo=swift&logoColor=white)](https://swift.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Apple%20Silicon%20%7C%20Intel-lightgrey)]()

**Keyboard Lock** is a lightweight, native macOS utility designed to temporarily disable all keyboard input with a single click. It is ideal for safely cleaning your MacBook keyboard or mechanical keyboard without shutting down your Mac, or preventing accidental keystrokes from children or pets.

---

## ✨ Features

- 🔒 **Total Keyboard Suppression**  
  Intercepts and swallows all keyboard events including character keys, function keys (F-keys), media keys, brightness, volume controls, and modifier flags using CoreGraphics `CGEventTap`.
- ⏱️ **Dual Unlock Mechanism**:
  1. **Physical Shortcut**: Hold **`Left Command (⌘)` + `Right Command (⌘)`** simultaneously for **5 seconds** (features a real-time progress bar and countdown indicator).
  2. **Trackpad / Mouse**: The unlock button in the app window can always be clicked using your pointer at any time.
- ⚡ **Lightweight & Pure Native**  
  Built 100% with Swift and Cocoa with **zero external dependencies**. No heavy frameworks, fast launch, and minimal memory footprint.
- 🛡️ **Event Tap Auto-Recovery**  
  Automatically recovers and re-enables the event tap if macOS disables it due to system timeouts.

---

## 📋 Requirements

- **macOS 11.0 (Big Sur)** or later (Universal binary support: Apple Silicon & Intel).
- **Accessibility** permission enabled in macOS System Settings.

---

## 🚀 Building & Installation

You can build the app directly from your terminal without opening Xcode:

### 1. Clone Repository
```bash
git clone https://github.com/Frdalf/Keyboard-Lock-Mac.git
cd Keyboard-Lock-Mac
```

### 2. Run the Build Script
Ensure the script is executable, then run:
```bash
chmod +x build.sh
./build.sh
```

This compiles `KeyboardLock.swift` with `-O` compiler optimization, packages it into a `Keyboard Lock.app` bundle with `Info.plist`, and applies an ad-hoc code signature.

### 3. Move to Applications
Move the newly created `Keyboard Lock.app` to your Applications directory:
```bash
mv "Keyboard Lock.app" /Applications/
```

---

## ⚙️ Accessibility Permissions

Because this utility intercepts and suppresses hardware keyboard signals at the system level via CoreGraphics `CGEventTap`, macOS requires Accessibility permission:

1. Open **System Settings** on your Mac.
2. Navigate to **Privacy & Security** › **Accessibility**.
3. Toggle **ON** the switch for **Keyboard Lock** (or click **+** to add it from `/Applications`).
4. If prompted, restart `Keyboard Lock`.

> [!NOTE]
> If Accessibility permissions have not been granted yet, the app will automatically prompt you with an alert and direct you to the settings pane.

---

## 📖 Usage Guide

1. Launch **Keyboard Lock**.
2. Click the **"Kunci Keyboard"** (Lock Keyboard) button.
3. The status indicator will switch to `🔒 Keyboard Terkunci`. All physical keyboard keys are now completely suppressed and safe to wipe down or clean.
4. To unlock:
   - Press and hold **`Left ⌘` + `Right ⌘`** simultaneously for **5 seconds**, **OR**
   - Click **"Buka Kunci (klik dengan trackpad)"** using your trackpad or mouse.

---

## 📂 Project Structure

```text
├── KeyboardLock.swift    # Core locking logic (KeyLocker) & Cocoa UI (AppDelegate)
├── build.sh              # Standalone build & .app bundling script
├── .gitignore            # Git ignore rules for macOS & build artifacts
├── LICENSE               # MIT License
└── README.md             # Project documentation
```

---

## 🛠️ GitHub Actions CI

This repository includes a continuous integration workflow (`.github/workflows/build.yml`) that automatically verifies and builds the application on a `macos-latest` runner on every push and pull request.

---

## 📄 License

This project is open-source software licensed under the [MIT License](LICENSE).
