import XCTest
@testable import XcodeAIAnswerSaver

final class MarkdownFormatterTests: XCTestCase {
    func testNormalizesLineEndingsAndKeepsCodeFences() {
        let input = "# Test\r\n\r\n```swift\r\nlet x = 1\r\n```"
        XCTAssertEqual(MarkdownFormatter.normalize(input), "# Test\n\n```swift\nlet x = 1\n```\n")
    }
    func testExtractsHeadingTitle() {
        XCTAssertEqual(MarkdownFormatter.title(from: "# Phoenix Terrain\n\nAnswer"), "Phoenix Terrain")
    }
}
