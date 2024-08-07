import XCTest
@testable import WMarkdown

final class WMarkdownTests: XCTestCase {

    func testBold() throws {
        let text = "<b>This Is Bold</b>"
        let expectedMarkdown = "**This Is Bold**"

        let markdown = self.convertText(text)
        XCTAssertEqual(expectedMarkdown, markdown)
    }

    func testItalic() throws {
        let text = "<i>italic text</i>"
        let expectedMarkdown = "*italic text*"

        let markdown = self.convertText(text)
        XCTAssertEqual(expectedMarkdown, markdown)
    }

    func testHeading1() throws {
        let text = "<h1>Heading 1</h1>"
        let expectedMarkdown = "# Heading 1"

        let markdown = self.convertText(text)
        XCTAssertEqual(expectedMarkdown, markdown)
    }

    func testHeading2() throws {
        let text = "<h2>Heading 2</h2>"
        let expectedMarkdown = "## Heading 2"

        let markdown = self.convertText(text)
        XCTAssertEqual(expectedMarkdown, markdown)
    }

    func testUnorderedList() throws {
        let text = "<ul><li>Item 1</li></ul>"
        let expectedMarkdown = "- Item 1"

        let markdown = self.convertText(text)
        XCTAssertEqual(expectedMarkdown, markdown)
    }

    func testBullet() throws {
        let text = "<ol><li>Item 1</li></ol>"
        let expectedMarkdown = "1. Item 1"

        let markdown = self.convertText(text)
        XCTAssertEqual(expectedMarkdown, markdown)
    }

    func testPhoneNumber() throws {
        let text = "Call 1-800-799-7233"
        let expectedMarkdown = "Call [1-800-799-7233](tel:1-800-799-7233)"

        let markdown = self.convertText(text)
        XCTAssertEqual(expectedMarkdown, markdown)
    }

    func testSMS() throws {
        let text = "Text 741741"
        let expectedMarkdown = "Text [741741](sms:741741)"

        let markdown = self.convertText(text)
        XCTAssertEqual(expectedMarkdown, markdown)
    }

    func testLink() throws {
        let text = "Visit Apple: https://apple.com"
        let expectedMarkdown = "Visit Apple: [https://apple.com](https://apple.com)"

        let markdown = self.convertText(text)
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

        let markdown = self.convertText(text)
        XCTAssertEqual(expectedMarkdown, markdown)
    }

    func testEmergency() throws {
        let text1 = "Call 911"
        let expectedMarkdown1 = "Call [911](tel:911)"
        let markdown1 = self.convertText(text1)

        let text2 = "Call 112"
        let expectedMarkdown2 = "Call [112](tel:112)"
        let markdown2 = self.convertText(text2)

        let text3 = "Call or text 988"
        let expectedMarkdown3 = "Call or text [988](tel:988)"
        let markdown3 = self.convertText(text3)

        let text4 = "Call 1-800-799-SAFE"
        let expectedMarkdown4 = "Call [1-800-799-SAFE](tel:18007997233)"
        let markdown4 = self.convertText(text4)

        let text5 = "Call 1-800-273-TALK"
        let expectedMarkdown5 = "Call [1-800-273-TALK](tel:18002738255)"
        let markdown5 = self.convertText(text5)

        XCTAssertEqual(expectedMarkdown1, markdown1)
        XCTAssertEqual(expectedMarkdown2, markdown2)
        XCTAssertEqual(expectedMarkdown3, markdown3)
        XCTAssertEqual(expectedMarkdown4, markdown4)
        XCTAssertEqual(expectedMarkdown5, markdown5)
    }

    func testNumberAndLink() throws {
        let text = "visit https://988lifeline.org/"
        let expectedMarkdown = "visit [https://988lifeline.org/](https://988lifeline.org/)"
        let markdown = self.convertText(text)
        XCTAssertEqual(expectedMarkdown, markdown)
    }

    func testHelpline() throws {
        let text = """
  1. Call 911 if you\'re having an emergency, or if you\'re just not sure who else to call\n2. Call or text 988 to talk to a free, confidential counselor from the Suicide & Crisis Lifeline (available 24/7 and in Spanish). Or visit https://988lifeline.org/\n3. Contact 1-800-799-7233 to reach the National Domestic Violence hotline. They can help if you\'re at risk of harm from a partner, family member, or acquaintance. Or visit https://www.thehotline.org/help/ to chat online with an advocate
"""

        let expectedMarkdown = """
  1. Call [911](tel:911) if you\'re having an emergency, or if you\'re just not sure who else to call\n2. Call or text [988](tel:988) to talk to a free, confidential counselor from the Suicide & Crisis Lifeline (available 24/7 and in Spanish). Or visit [https://988lifeline.org/](https://988lifeline.org/)\n3. Contact [1-800-799-7233](tel:1-800-799-7233) to reach the National Domestic Violence hotline. They can help if you\'re at risk of harm from a partner, family member, or acquaintance. Or visit [https://www.thehotline.org/help/](https://www.thehotline.org/help/) to chat online with an advocate
"""

        let markdown = self.convertText(text)
        XCTAssertEqual(expectedMarkdown, markdown)
    }

    func testBoldItalicTempFixConverstion() throws {
        let text = """
Hello, *Swift* readers! Hello2, **Swift**! Hello3, <b>Swift</b>!

    We can make text <i>italic</i>, ***bold italic***, or ~~striked through~~.

    You can even create test links https://www.twitter.com that actually work.
"""

        let expectedMarkdown = """
Hello, **Swift** readers! Hello2, **Swift**! Hello3, **Swift**!

    We can make text *italic*, ***bold italic***, or ~~striked through~~.

    You can even create test links [https://www.twitter.com](https://www.twitter.com) that actually work.
"""

        let markdown = self.convertText(text)
        XCTAssertEqual(expectedMarkdown, markdown)
    }

    func testBoldItalicTempFixConverstionAlternate() throws {
        let text = """
*These* techniques have helped a lot of people just like you

But to get the most benefit, I <i>need</i> you to do something...
"""

        let expectedMarkdown = """
**These** techniques have helped a lot of people just like you

But to get the most benefit, I *need* you to do something...
"""

        let markdown = self.convertText(text)
        XCTAssertEqual(expectedMarkdown, markdown)
    }

    private func convertText(_ text: String) -> String {
        return text.markdownWithPrelim
    }

    func testDesignControlNumbers() throws {
        let text = "The National Domestic Abuse Helpline (US):\nhttps://www.thehotline.org - online anonymous chat \n1-800-799-7233 or 1-800-787-3224 (TTY)"
        let expectedMarkdown = "The National Domestic Abuse Helpline (US):\n[https://www.thehotline.org](https://www.thehotline.org) - online anonymous chat \n[1-800-799-7233](tel:1-800-799-7233) or [1-800-787-3224](tel:1-800-787-3224) (TTY)"
        let markdown = self.convertText(text)
        XCTAssertEqual(expectedMarkdown, markdown)
    }

    func testDesignControlNumbersUS() throws {
        let text = "The Family Advocacy Network: 1-800-924-2624"
        let expectedMarkdown = "The Family Advocacy Network: [1-800-924-2624](tel:1-800-924-2624)"
        let markdown = self.convertText(text)
        XCTAssertEqual(expectedMarkdown, markdown)
    }

    func testWhiteRibbonAltAUS() throws {
        let text = "The White Ribbon Alternative: 1880-RESPECT"
        let expectedMarkdown = "The White Ribbon Alternative: [1880-RESPECT](tel:18807377328)"
        let markdown = self.convertText(text)
        XCTAssertEqual(expectedMarkdown, markdown)
    }
}
