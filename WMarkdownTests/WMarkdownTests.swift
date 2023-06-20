import XCTest
@testable import WMarkdown

final class WMarkdownTests: XCTestCase {

    func testBold() throws {
        let textOne = "<b>This Is Bold</b>"
        let expectedMarkdownOne = "**This Is Bold**"

        let markdownOne = textOne.markdown
        XCTAssertEqual(expectedMarkdownOne, markdownOne)
    }

    func testItalic() throws {
        let textOne = "<i>italic text</i>"
        let expectedMarkdownOne = "*italic text*"

        let markdownOne = textOne.markdown
        XCTAssertEqual(expectedMarkdownOne, markdownOne)
    }

    func testHeading1() throws {
        let textOne = "<h1>Heading 1</h1>"
        let expectedMarkdownOne = "# Heading 1"

        let markdownOne = textOne.markdown
        XCTAssertEqual(expectedMarkdownOne, markdownOne)
    }

    func testHeading2() throws {
        let textOne = "<h2>Heading 2</h2>"
        let expectedMarkdownOne = "## Heading 2"

        let markdownOne = textOne.markdown
        XCTAssertEqual(expectedMarkdownOne, markdownOne)
    }

    func testUnorderedList() throws {
        let textOne = "<ul><li>Item 1</li></ul>"
        let expectedMarkdownOne = "- Item 1"

        let markdownOne = textOne.markdown
        XCTAssertEqual(expectedMarkdownOne, markdownOne)
    }

    func testBullet() throws {
        let textOne = "<ol><li>Item 1</li></ol>"
        let expectedMarkdownOne = "1. Item 1"

        let markdownOne = textOne.markdown
        XCTAssertEqual(expectedMarkdownOne, markdownOne)
    }

    func testPhoneNumber() throws {
        let textOne = "Call 1-800-799-7233"
        let expectedMarkdownOne = "Call [1-800-799-7233](tel:1-800-799-7233)"

        let markdownOne = textOne.markdown
        XCTAssertEqual(expectedMarkdownOne, markdownOne)
    }

    func testSMS() throws {
        let textOne = "Text 741741"
        let expectedMarkdownOne = "Text [741741](sms:741741)"

        let markdownOne = textOne.markdown
        XCTAssertEqual(expectedMarkdownOne, markdownOne)
    }

    func testLink() throws {
        let textOne = "Visit Apple: https://apple.com"
        let expectedMarkdownOne = "Visit Apple: [https://apple.com](https://apple.com)"

        let markdownOne = textOne.markdown
        XCTAssertEqual(expectedMarkdownOne, markdownOne)
    }

    func testLargeConverstion() throws {
        let textOne = """
Hello, <b>Swift</b> readers!

    We can make text <i>italic</i>, ***bold italic***, or ~~striked through~~.

    You can even create test links https://www.twitter.com that actually work.
"""

        let expectedMarkdownOne = """
Hello, **Swift** readers!

    We can make text *italic*, ***bold italic***, or ~~striked through~~.

    You can even create test links [https://www.twitter.com](https://www.twitter.com) that actually work.
"""

        let markdownOne = textOne.markdown
        XCTAssertEqual(expectedMarkdownOne, markdownOne)
    }

    func testEmergency() throws {
        let text1 = "Call 911"
        let expectedMarkdown1 = "Call [911](tel:911)"
        let markdown1 = text1.markdown

        let text2 = "Call 112"
        let expectedMarkdown2 = "Call [112](tel:112)"
        let markdown2 = text2.markdown

        let text3 = "Call 988"
        let expectedMarkdown3 = "Call [988](tel:988)"
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
}
