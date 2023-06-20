//
//  Markdown.swift
//  WMarkdown
//
//  Created by Malcolmn Roberts on 2023/06/19.
//

import Foundation
import UIKit

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

        let linkConvertedString = convertTextToMarkdown(markdownAsString)
        return linkConvertedString
    }

    static func convertTextToMarkdown(_ input: String) -> String {
        var markdownString = input
        let textRange = NSRange(location: 0, length: input.utf16.count)

        let linkDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let linkMatches = linkDetector?.matches(in: markdownString, options: [], range: NSRange(location: 0, length: markdownString.utf16.count))

        for match in linkMatches?.reversed() ?? [] {
            if let range = Range(match.range, in: markdownString) {
                let linkURL = markdownString[range]
                let markdownLink = "[\(linkURL)](\(linkURL))"
                markdownString = markdownString.replacingCharacters(in: range, with: markdownLink)
            }
        }

        let matches = MarkdownBuilder.getAllElements(from: markdownString, range: textRange)

        for match in matches.reversed() {
            if let range = Range(match.range, in: markdownString) {
                switch match.type {
                case .url:
                    continue
                case .email:

                    let markdownLink = "[\(match.element.text)](\(match.type.action)\(match.element.text))"
                    markdownString = markdownString.replacingCharacters(in: range, with: markdownLink)
                    
                case .phone, .sms:

                    let markdownLink = "[\(match.element.text)](\(match.type.action)\(convertPhoneNumberToNumbers(match.element.text)))"
                    markdownString = markdownString.replacingOccurrences(of: match.element.text, with: markdownLink)

                case .emergency:

                    let previousIndex = markdownString.index(range.lowerBound, offsetBy: -1)
                    let nextIndex = markdownString.index(range.upperBound, offsetBy: 0)

                    if previousIndex >= markdownString.startIndex && nextIndex < markdownString.endIndex {
                        let leftCharacter = markdownString[previousIndex]
                        let rightCharacter = markdownString[nextIndex]

                        if leftCharacter.isWhitespace && rightCharacter.isWhitespace {
                            let markdownLink = "[\(match.element.text)](\(match.type.action)\(convertPhoneNumberToNumbers(match.element.text)))"
                            markdownString = markdownString.replacingCharacters(in: range, with: markdownLink)
                        }
                    } else {
                        let markdownLink = "[\(match.element.text)](\(match.type.action)\(convertPhoneNumberToNumbers(match.element.text)))"
                        markdownString = markdownString.replacingCharacters(in: range, with: markdownLink)
                    }
                }
            }
        }

        return markdownString
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
}
