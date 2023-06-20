//
//  Markdown.swift
//  WMarkdown
//
//  Created by Malcolmn Roberts on 2023/06/19.
//

import Foundation

enum MarkdownConvertions: CaseIterable {
    case heading1
    case heading2
    case bold
    case italic
    case list
    case bullet

    var openingTag: String {
        switch self {
        case .heading1:
            return "<h1>"
        case .heading2:
            return "<h2>"
        case .bold:
            return "<b>"
        case .italic:
            return "<i>"
        case .list:
            return "<ul><li>"
        case .bullet:
            return "<ol><li>"
        }
    }

    var closingTag: String {
        switch self {
        case .heading1:
            return "</h1>"
        case .heading2:
            return "</h2>"
        case .bold:
            return "</b>"
        case .italic:
            return "</i>"
        case .list:
            return "</li></ul>"
        case .bullet:
            return "</li></ol>"
        }
    }

    var markdownOpeningTag: String {
        switch self {
        case .heading1:
            return "# "
        case .heading2:
            return "## "
        case .bold:
            return "**"
        case .italic:
            return "*"
        case .list:
            return "- "
        case .bullet:
            return "1. "
        }
    }

    var markdownClosingTag: String {
        switch self {
        case .heading1:
            return ""
        case .heading2:
            return ""
        case .bold:
            return "**"
        case .italic:
            return "*"
        case .list:
            return ""
        case .bullet:
            return ""
        }
    }
}

typealias ElementTuple = (range: NSRange, element: MarkElement, type: MarkType)

struct Markdown {
    static func toMarkdown(from text: String) -> String {
        let markdownAsString = MarkdownConvertions.allCases.reduce(text) { result, textFormattingTag in
                    result
                        .replacingOccurrences(of: textFormattingTag.openingTag, with: textFormattingTag.markdownOpeningTag)
                        .replacingOccurrences(of: textFormattingTag.closingTag, with: textFormattingTag.markdownClosingTag)
                }

        let linkConvertedString = parseTextAndExtractElements(markdownAsString)
        return linkConvertedString
    }

    /// Use regex
    private static func parseTextAndExtractElements(_ text: String) -> String {
        var textString = text
        let textLength = textString.utf16.count
        let textRange = NSRange(location: 0, length: textLength)

        let tuples = MarkdownBuilder.getAllElements(from: textString, range: textRange)
        for tuple in tuples {
            switch tuple.type {
            case .url:
                textString = textString.replacingOccurrences(of: tuple.element.text, with: "[\(tuple.element.text)](\(tuple.element.text))")
            case .email:
                textString = textString.replacingOccurrences(of: tuple.element.text, with: "[\(tuple.element.text)](mailto:\(tuple.element.text))")
            case .phone, .sms, .emergency:
                textString = replaceTextWithPhoneNumber(textString, tupleText: tuple.element.text, markType: tuple.type)
            }
        }

        return textString
    }

    private static func replaceTextWithPhoneNumber(_ text: String, tupleText: String ,markType: MarkType) -> String {
        if text.isURL { return text }

        switch markType {
        case .url, .email:
            return text
        case .phone:
            return text.replacingOccurrences(of: tupleText, with: "[\(tupleText)](tel:\(tupleText))")
        case .sms:
            return text.replacingOccurrences(of: tupleText, with: "[\(tupleText)](sms:\(tupleText))")
        case .emergency:
            // here to check for SAFE and TALK
            return text.replacingOccurrences(of: tupleText, with: "[\(tupleText)](tel:\(convertPhoneNumberToNumbers(tupleText)))")
        }
    }

    private static func convertPhoneNumberToNumbers(_ phoneNumber: String) -> String {
        if phoneNumber.replacingOccurrences(of: "-", with: "").isNumeric {
            return phoneNumber
        }

        let characterMap: [Character: Character] = [
            "A": "2", "B": "2", "C": "2",
            "D": "3", "E": "3", "F": "3",
            "G": "4", "H": "4", "I": "4",
            "J": "5", "K": "5", "L": "5",
            "M": "6", "N": "6", "O": "6",
            "P": "7", "Q": "7", "R": "7", "S": "7",
            "T": "8", "U": "8", "V": "8",
            "W": "9", "X": "9", "Y": "9", "Z": "9"
        ]

        var convertedPhoneNumber = ""

        for character in phoneNumber {
            if let numberCharacter = characterMap[Character(character.uppercased())] {
                convertedPhoneNumber += String(numberCharacter)
            } else if character.isNumber {
                convertedPhoneNumber += String(character)
            }
        }

        return convertedPhoneNumber
    }
}

extension String {
    var isNumeric: Bool {
        return !(self.isEmpty) && self.allSatisfy { $0.isNumber }
    }

    var isURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
        return matches.count > 0
    }
}
