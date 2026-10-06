import Foundation
import XcodeKit

final class SourceEditorExtension: NSObject, XCSourceEditorExtension {
    var commandDefinitions: [[XCSourceEditorCommandDefinitionKey: Any]] {
        [[
            .identifierKey: "com.gabrielnetto.xcode-ai-answer-saver.save-clipboard",
            .classNameKey: "SourceEditorCommand",
            .nameKey: "Save Clipboard as Markdown"
        ]]
    }
}
