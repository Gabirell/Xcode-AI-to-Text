import Foundation

enum MarkdownFormatter {
    static func normalize(_ input: String) -> String {
        var text = input.replacingOccurrences(of: "\r\n", with: "\n").replacingOccurrences(of: "\r", with: "\n").trimmingCharacters(in: .whitespacesAndNewlines)
        if !text.hasSuffix("\n") { text += "\n" }
        return text
    }
    static func title(from markdown: String) -> String {
        for line in markdown.split(separator: "\n", omittingEmptySubsequences: true) {
            let value = String(line).trimmingCharacters(in: .whitespaces)
            if value.hasPrefix("# ") { return String(value.dropFirst(2)).trimmingCharacters(in: .whitespaces) }
        }
        let first = markdown.split(separator: "\n", omittingEmptySubsequences: true).first.map(String.init) ?? "AI Answer"
        return String(first.prefix(70))
    }
}

enum FileNameSanitizer {
    static func sanitize(_ value: String) -> String {
        let invalid = CharacterSet(charactersIn: "/:\\?%*|\"<>\n\r")
        let cleaned = value.components(separatedBy: invalid).joined(separator: "-")
        return cleaned.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "AI Answer" : cleaned.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
