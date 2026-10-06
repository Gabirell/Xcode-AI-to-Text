import Cocoa
import ApplicationServices

@main
final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private let saver = AnswerSaver()
    private var globalMonitor: Any?

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button?.title = "AI Saver"
        let menu = NSMenu()
        menu.addItem(withTitle: "Save Xcode AI Answer", action: #selector(saveAnswer), keyEquivalent: "s")
        menu.addItem(withTitle: "Open Answers Folder", action: #selector(openFolder), keyEquivalent: "")
        menu.addItem(.separator())
        menu.addItem(withTitle: "Accessibility Permission…", action: #selector(openAccessibility), keyEquivalent: "")
        menu.addItem(.separator())
        menu.addItem(withTitle: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        statusItem.menu = menu
        globalMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.keyDown]) { [weak self] event in
            guard event.modifierFlags.contains([.command, .option]), event.charactersIgnoringModifiers?.lowercased() == "s" else { return }
            self?.saveAnswer()
        }
    }

    @objc private func saveAnswer() {
        Task { @MainActor in
            do {
                let result = try await saver.captureAndSave()
                let alert = NSAlert()
                alert.messageText = "AI answer saved"
                alert.informativeText = "\(result.url.path)\n\nThe Markdown is also on your clipboard."
                alert.alertStyle = .informational
                alert.runModal()
            } catch {
                let alert = NSAlert(error: error)
                alert.alertStyle = .warning
                alert.runModal()
            }
        }
    }

    @objc private func openFolder() { NSWorkspace.shared.open(saver.answersDirectory) }

    @objc private func openAccessibility() {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary
        _ = AXIsProcessTrustedWithOptions(options)
    }

    deinit {
        if let monitor = globalMonitor { NSEvent.removeMonitor(monitor) }
    }
}
