//
//  WMarkdown.swift
//  WMarkdown
//
//  Created by Malcolmn Roberts on 2023/06/19.
//

import Foundation

extension String {
    public var markdown: String {
        return Markdown.toMarkdown(from: self)
    }

    /// This is a temporary variable to will convert a single * to a **
    public var markdownWithPrelim: String {
        let replacingString = convertToBold(self)
        return Markdown.toMarkdown(from: replacingString)
    }

    private func convertToBold(_ input: String) -> String {
        var convertedText = ""
        var prevChar: Character?

        for char in input {
            if char == "*" {
                if let prevChar = prevChar, prevChar != "*", let nextChar = input.dropFirst().first, nextChar != "*" {
                    convertedText.append("**")
                } else {
                    convertedText.append(char)
                }
            } else {
                convertedText.append(char)
            }

            prevChar = char
        }

        let replaceExtraBold = convertedText.replacingOccurrences(of: "***", with: "**")
        return replaceExtraBold.replacingOccurrences(of: "****", with: "***")
    }
}
