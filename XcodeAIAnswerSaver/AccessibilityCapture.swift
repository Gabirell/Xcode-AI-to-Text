import Cocoa
import ApplicationServices

enum AccessibilityCapture {
    static func captureXcodeAIAnswer() throws -> String {
        guard AXIsProcessTrusted() else { throw AnswerSaverError.accessibilityDenied }
        guard let app = NSRunningApplication.runningApplications(withBundleIdentifier: "com.apple.dt.Xcode").first else {
            throw AnswerSaverError.noAnswerFound
        }
        let element = AXUIElementCreateApplication(app.processIdentifier)
        var windows: CFTypeRef?
        guard AXUIElementCopyAttributeValue(element, kAXWindowsAttribute as CFString, &windows) == .success,
              let windowArray = windows as? [AXUIElement] else { throw AnswerSaverError.noAnswerFound }
        var candidates: [String] = []
        for window in windowArray { collectText(from: window, into: &candidates, depth: 0) }
        let filtered = candidates.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { $0.count > 80 }
        guard let best = filtered.max(by: { score($0) < score($1) }) else { throw AnswerSaverError.noAnswerFound }
        return best
    }
    private static func collectText(from element: AXUIElement, into result: inout [String], depth: Int) {
        guard depth < 20 else { return }
        for attribute in [kAXValueAttribute, kAXDescriptionAttribute, kAXTitleAttribute, kAXHelpAttribute] {
            var value: CFTypeRef?
            if AXUIElementCopyAttributeValue(element, attribute as CFString, &value) == .success,
               let string = value as? String, looksLikeAnswer(string) { result.append(string) }
        }
        var children: CFTypeRef?
        if AXUIElementCopyAttributeValue(element, kAXChildrenAttribute as CFString, &children) == .success,
           let array = children as? [AXUIElement] {
            for child in array { collectText(from: child, into: &result, depth: depth + 1) }
        }
    }
    private static func looksLikeAnswer(_ text: String) -> Bool {
        let lower = text.lowercased()
        if lower.contains("xcode") && lower.count < 150 { return false }
        return text.count > 80 && (text.contains("\n") || text.contains("```") || text.count > 200)
    }
    private static func score(_ text: String) -> Int {
        var value = min(text.count, 10_000)
        if text.contains("```") { value += 2_000 }
        if text.contains("\n#") { value += 500 }
        if text.contains("\n- ") { value += 200 }
        return value
    }
}
