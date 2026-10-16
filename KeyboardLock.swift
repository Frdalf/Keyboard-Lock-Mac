import Cocoa

// MARK: - Logika penguncian keyboard

final class KeyLocker {
    static let shared = KeyLocker()

    private var tap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?
    private var holdTimer: Timer?
    private var holdStart: Date?

    private(set) var isLocked = false
    var onStateChange: ((Bool) -> Void)?
    var onHoldProgress: ((Double?) -> Void)?   // nil = tidak sedang ditahan

    let holdDuration: TimeInterval = 5.0

    // Bit flag spesifik perangkat untuk Command kiri/kanan
    private let leftCmdMask: UInt64  = 0x00000008
    private let rightCmdMask: UInt64 = 0x00000010

    func lock() -> Bool {
        guard !isLocked else { return true }

        let types: [UInt32] = [
            CGEventType.keyDown.rawValue,
            CGEventType.keyUp.rawValue,
            CGEventType.flagsChanged.rawValue,
            14 // NX_SYSDEFINED: tombol media, brightness, volume
        ]
        let mask = types.reduce(CGEventMask(0)) { $0 | (CGEventMask(1) << $1) }

        guard let tap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: mask,
            callback: eventCallback,
            userInfo: nil
        ) else {
            return false // biasanya karena izin Accessibility belum diberikan
        }

        self.tap = tap
        runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)
        CFRunLoopAddSource(CFRunLoopGetMain(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: tap, enable: true)

        isLocked = true
        onStateChange?(true)
        return true
    }

    func unlock() {
        guard isLocked else { return }
        cancelHold()
        if let tap = tap { CGEvent.tapEnable(tap: tap, enable: false) }
        if let src = runLoopSource { CFRunLoopRemoveSource(CFRunLoopGetMain(), src, .commonModes) }
        tap = nil
        runLoopSource = nil
        isLocked = false
        onStateChange?(false)
    }

    fileprivate func reenableTap() {
        if let tap = tap { CGEvent.tapEnable(tap: tap, enable: true) }
    }

    fileprivate func handleFlags(_ flags: CGEventFlags) {
        let raw = flags.rawValue
        let bothCmd = (raw & leftCmdMask != 0) && (raw & rightCmdMask != 0)
        if bothCmd {
            startHoldIfNeeded()
        } else {
            cancelHold()
        }
    }

    private func startHoldIfNeeded() {
        guard holdTimer == nil else { return }
        holdStart = Date()
        onHoldProgress?(0)
        holdTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            guard let self = self, let start = self.holdStart else { return }
            let progress = Date().timeIntervalSince(start) / self.holdDuration
            if progress >= 1 {
                self.unlock()
            } else {
                self.onHoldProgress?(progress)
            }
        }
    }

    private func cancelHold() {
        holdTimer?.invalidate()
        holdTimer = nil
        holdStart = nil
        onHoldProgress?(nil)
    }
}

private func eventCallback(proxy: CGEventTapProxy,
                           type: CGEventType,
                           event: CGEvent,
                           userInfo: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
    let locker = KeyLocker.shared

    // macOS bisa mematikan tap kalau lambat; nyalakan lagi
    if type == .tapDisabledByTimeout || type == .tapDisabledByUserInput {
        locker.reenableTap()
        return nil
    }

    if type == .flagsChanged {
        locker.handleFlags(event.flags)
    }

    // Telan semua event keyboard selama terkunci
    return nil
}

// MARK: - UI

final class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    let statusLabel = NSTextField(labelWithString: "")
    let hintLabel = NSTextField(wrappingLabelWithString: "")
    let button = NSButton(title: "", target: nil, action: nil)
    let progress = NSProgressIndicator()

    func applicationDidFinishLaunching(_ notification: Notification) {
        window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 360, height: 230),
                          styleMask: [.titled, .closable, .miniaturizable],
                          backing: .buffered, defer: false)
        window.title = "Keyboard Lock"
        window.center()

        statusLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        statusLabel.alignment = .center

        hintLabel.alignment = .center
        hintLabel.textColor = .secondaryLabelColor
        hintLabel.font = .systemFont(ofSize: 12)

        button.bezelStyle = .rounded
        button.controlSize = .large
        button.target = self
        button.action = #selector(toggle)

        progress.isIndeterminate = false
        progress.minValue = 0
        progress.maxValue = 1
        progress.isHidden = true

        let stack = NSStackView(views: [statusLabel, hintLabel, button, progress])
        stack.orientation = .vertical
        stack.spacing = 14
        stack.edgeInsets = NSEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
        stack.translatesAutoresizingMaskIntoConstraints = false
        window.contentView = stack
        progress.widthAnchor.constraint(equalToConstant: 260).isActive = true
        hintLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true

        let locker = KeyLocker.shared
        locker.onStateChange = { [weak self] _ in self?.refresh() }
        locker.onHoldProgress = { [weak self] p in
            guard let self = self else { return }
            if let p = p {
                self.progress.isHidden = false
                self.progress.doubleValue = p
                let left = Int(ceil((1 - p) * locker.holdDuration))
                self.hintLabel.stringValue = "Tahan terus… \(left) detik lagi"
            } else {
                self.progress.isHidden = true
                self.refresh()
            }
        }

        refresh()
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    func refresh() {
        let locked = KeyLocker.shared.isLocked
        statusLabel.stringValue = locked ? "🔒 Keyboard Terkunci" : "⌨️ Keyboard Aktif"
        hintLabel.stringValue = locked
            ? "Untuk membuka: tahan ⌘ kiri + ⌘ kanan bersamaan selama 5 detik."
            : "Klik tombol di bawah, lalu bersihkan keyboard dengan tenang."
        button.title = locked ? "Buka Kunci (klik dengan trackpad)" : "Kunci Keyboard"
    }

    @objc func toggle() {
        let locker = KeyLocker.shared
        if locker.isLocked {
            locker.unlock()
            return
        }
        if !ensureAccessibility() { return }
        if !locker.lock() {
            showAlert("Gagal mengunci keyboard",
                      "Pastikan Keyboard Lock sudah diizinkan di System Settings › Privacy & Security › Accessibility, lalu buka ulang aplikasi.")
        }
    }

    func ensureAccessibility() -> Bool {
        let opts = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary
        if AXIsProcessTrustedWithOptions(opts) { return true }
        showAlert("Butuh izin Accessibility",
                  "Aktifkan Keyboard Lock di System Settings › Privacy & Security › Accessibility, lalu coba lagi.")
        return false
    }

    func showAlert(_ title: String, _ msg: String) {
        let a = NSAlert()
        a.messageText = title
        a.informativeText = msg
        a.runModal()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool { true }

    func applicationWillTerminate(_ notification: Notification) {
        KeyLocker.shared.unlock()
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.regular)
app.run()
