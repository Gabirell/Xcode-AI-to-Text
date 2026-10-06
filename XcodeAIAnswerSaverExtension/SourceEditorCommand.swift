import Foundation
import XcodeKit
import AppKit

final class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) {
        guard let text = NSPasteboard.general.string(forType: .string), !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            completionHandler(nil)
            return
        }
        let directory = FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent("Documents", isDirectory: true)
            .appendingPathComponent("Xcode AI Answers", isDirectory: true)
        do {
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
            let title = MarkdownFormatter.title(from: text)
            let url = directory.appendingPathComponent(FileNameSanitizer.sanitize(title) + ".md")
            try MarkdownFormatter.normalize(text).write(to: url, atomically: true, encoding: .utf8)
            completionHandler(nil)
        } catch { completionHandler(error) }
    }
}
