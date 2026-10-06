import Cocoa
import ApplicationServices

struct SavedAnswer { let url: URL; let markdown: String }

enum AnswerSaverError: LocalizedError {
    case accessibilityDenied
    case noAnswerFound
    case emptyClipboard
    var errorDescription: String? {
        switch self {
        case .accessibilityDenied: return "Accessibility access is required to read the Xcode AI chat. Enable Xcode AI Answer Saver under System Settings > Privacy & Security > Accessibility."
        case .noAnswerFound: return "I could not find readable AI answer text in the Xcode window. The clipboard was not changed."
        case .emptyClipboard: return "No text was found on the clipboard."
        }
    }
}

@MainActor
final class AnswerSaver {
    let answersDirectory: URL = FileManager.default.homeDirectoryForCurrentUser
        .appendingPathComponent("Documents", isDirectory: true)
        .appendingPathComponent("Xcode AI Answers", isDirectory: true)

    func captureAndSave() async throws -> SavedAnswer {
        let captured = AXIsProcessTrusted() ? (try? AccessibilityCapture.captureXcodeAIAnswer()) ?? "" : ""
        let finalText: String
        if !captured.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            finalText = MarkdownFormatter.normalize(captured)
        } else {
            finalText = try clipboardText()
        }
        guard !finalText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { throw AnswerSaverError.noAnswerFound }
        try FileManager.default.createDirectory(at: answersDirectory, withIntermediateDirectories: true)
        let title = MarkdownFormatter.title(from: finalText)
        let filename = FileNameSanitizer.sanitize(title.isEmpty ? "AI Answer" : title) + ".md"
        let url = answersDirectory.appendingPathComponent(filename)
        try finalText.write(to: url, atomically: true, encoding: .utf8)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(finalText, forType: .string)
        return SavedAnswer(url: url, markdown: finalText)
    }
    private func clipboardText() throws -> String {
        guard let text = NSPasteboard.general.string(forType: .string), !text.isEmpty else { throw AnswerSaverError.emptyClipboard }
        return text
    }
}
