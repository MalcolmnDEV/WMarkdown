import XCTest
@testable import WMarkdown

final class WMarkdownTests: XCTestCase {

    func testBold() throws {
        let text = "<b>This Is Bold</b>"
        let expectedMarkdown = "**This Is Bold**"

        let markdown = text.markdown
        XCTAssertEqual(expectedMarkdown, markdown)
    }

    func testItalic() throws {
        let text = "<i>italic text</i>"
        let expectedMarkdown = "*italic text*"

        let markdown = text.markdown
        XCTAssertEqual(expectedMarkdown, markdown)
    }

    func testHeading1() throws {
        let text = "<h1>Heading 1</h1>"
        let expectedMarkdown = "# Heading 1"

        let markdown = text.markdown
        XCTAssertEqual(expectedMarkdown, markdown)
    }

    func testHeading2() throws {
        let text = "<h2>Heading 2</h2>"
        let expectedMarkdown = "## Heading 2"

        let markdown = text.markdown
        XCTAssertEqual(expectedMarkdown, markdown)
    }

    func testUnorderedList() throws {
        let text = "<ul><li>Item 1</li></ul>"
        let expectedMarkdown = "- Item 1"

        let markdown = text.markdown
        XCTAssertEqual(expectedMarkdown, markdown)
    }

    func testBullet() throws {
        let text = "<ol><li>Item 1</li></ol>"
        let expectedMarkdown = "1. Item 1"

        let markdown = text.markdown
        XCTAssertEqual(expectedMarkdown, markdown)
    }

    func testPhoneNumber() throws {
        let text = "Call 1-800-799-7233"
        let expectedMarkdown = "Call [1-800-799-7233](tel:1-800-799-7233)"

        let markdown = text.markdown
        XCTAssertEqual(expectedMarkdown, markdown)
    }

    func testSMS() throws {
        let text = "Text 741741"
        let expectedMarkdown = "Text [741741](sms:741741)"

        let markdown = text.markdown
        XCTAssertEqual(expectedMarkdown, markdown)
    }

    func testLink() throws {
        let text = "Visit Apple: https://apple.com"
        let expectedMarkdown = "Visit Apple: [https://apple.com](https://apple.com)"

        let markdown = text.markdown
        XCTAssertEqual(expectedMarkdown, markdown)
    }

    func testLargeConverstion() throws {
        let text = """
Hello, <b>Swift</b> readers!

    We can make text <i>italic</i>, ***bold italic***, or ~~striked through~~.

    You can even create test links https://www.twitter.com that actually work.
"""

        let expectedMarkdown = """
Hello, **Swift** readers!

    We can make text *italic*, ***bold italic***, or ~~striked through~~.

    You can even create test links [https://www.twitter.com](https://www.twitter.com) that actually work.
"""

        let markdown = text.markdown
        XCTAssertEqual(expectedMarkdown, markdown)
    }

    func testEmergency() throws {
        let text1 = "Call 911"
        let expectedMarkdown1 = "Call [911](tel:911)"
        let markdown1 = text1.markdown

        let text2 = "Call 112"
        let expectedMarkdown2 = "Call [112](tel:112)"
        let markdown2 = text2.markdown

        let text3 = "Call or text 988"
        let expectedMarkdown3 = "Call or text [988](tel:988)"
        let markdown3 = text3.markdown

        let text4 = "Call 1-800-799-SAFE"
        let expectedMarkdown4 = "Call [1-800-799-SAFE](tel:18007997233)"
        let markdown4 = text4.markdown

        let text5 = "Call 1-800-273-TALK"
        let expectedMarkdown5 = "Call [1-800-273-TALK](tel:18002738255)"
        let markdown5 = text5.markdown

        XCTAssertEqual(expectedMarkdown1, markdown1)
        XCTAssertEqual(expectedMarkdown2, markdown2)
        XCTAssertEqual(expectedMarkdown3, markdown3)
        XCTAssertEqual(expectedMarkdown4, markdown4)
        XCTAssertEqual(expectedMarkdown5, markdown5)
    }

    func testNumberAndLink() throws {
        let text = "visit https://988lifeline.org/"
        let expectedMarkdown = "visit [https://988lifeline.org/](https://988lifeline.org/)"
        let markdown = text.markdown
        XCTAssertEqual(expectedMarkdown, markdown)
    }
}
