//
//  MarkdownBuilder.swift
//  WMarkdown
//
//  Created by Malcolmn Roberts on 2023/06/19.
//

import Foundation

typealias MarkFilterPredicate = ((String) -> Bool)

struct MarkdownBuilder {

    static func getAllElements(from text: String, range: NSRange) -> [ElementTuple] {
        var elements: [ElementTuple] = []
        for markType in MarkType.allCases {
            let typeElements = createElements(from: text, for: markType, range: range, filterPredicate: nil)
            elements.append(contentsOf: typeElements)
        }
        return elements
    }

    private static func createElements(from text: String,
                                            for type: MarkType,
                                                range: NSRange,
                                                minLength: Int = 2,
                                                filterPredicate: MarkFilterPredicate?) -> [ElementTuple] {

        let matches = MarkRegex.getElements(from: text, with: type.pattern, range: range)
        let nsstring = text as NSString
        var elements: [ElementTuple] = []

        for match in matches where match.range.length > minLength {
            let word = nsstring.substring(with: match.range)
                .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if filterPredicate?(word) ?? true {
                let element = MarkElement.create(with: type, text: word)
                elements.append((match.range, element, type))
            }
        }
        return elements
    }
}

extension String {
    func trim(to maximumCharacters: Int) -> String {
        return "\(self[..<index(startIndex, offsetBy: maximumCharacters)])" + "..."
    }
}
