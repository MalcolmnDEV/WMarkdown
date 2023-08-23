//
//  MarkRegex.swift
//  WMarkdown
//
//  Created by Malcolmn Roberts on 2023/06/19.
//

import Foundation

struct MarkRegex {

    static let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    static let urlPattern = "(^|[\\s.:;?\\-\\]<\\(])" +
        "((https?://|www\\.|pic\\.)[-\\w;/?:@&=+$\\|\\_.!~*\\|'()\\[\\]%#,☺]+[\\w/#](\\(\\))?)" +
    "(?=$|[\\s',\\|\\(\\).:;?\\-\\[\\]>\\)])"
    static let phonePattern = "([+]?1+[-]?)?+([(]?+([0-9]{3})?+[)]?)?+[-]?+[0-9]{3}+[-]?+[0-9]{4}"
    static let smsPattern = "(8009444773|9714200294|741741|22522|678678|233733)"
    static let emergencyPattern = "(911|112|1-800-799-SAFE|1-800-273-TALK|988)"

    private static var cachedRegularExpressions: [String: NSRegularExpression] = [:]

    static func getElements(from text: String, with pattern: String, range: NSRange) -> [NSTextCheckingResult] {
        guard let elementRegex = regularExpression(for: pattern) else { return [] }

        var matches = elementRegex.matches(in: text, options: [], range: range)
        if matches.count == 0 && pattern == phonePattern {
            // use native data detector as extra check
            matches = nativePhoneRegex(text: text, range: range)
        }

        return matches
    }

    private static func regularExpression(for pattern: String) -> NSRegularExpression? {
        if let regex = cachedRegularExpressions[pattern] {
            return regex
        } else if let createdRegex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) {
            cachedRegularExpressions[pattern] = createdRegex
            return createdRegex
        } else {
            return nil
        }
    }

    private static func nativePhoneRegex(text: String, range: NSRange) -> [NSTextCheckingResult] {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: text, range: NSRange(text.startIndex..., in: text))

            var resultsArray = [NSTextCheckingResult]()

            // ensure emergency numbers are excluded
            guard let elementRegex = regularExpression(for: emergencyPattern) else { return resultsArray }
            var emergencymatches: [String] = []
            for em in elementRegex.matches(in: text, options: [], range: range) {
                let nsstring = text as NSString
                let word = nsstring.substring(with: em.range)
                    .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                emergencymatches.append(word)
            }

            for match in matches {
                if match.resultType == .phoneNumber, let number = match.phoneNumber, !emergencymatches.contains(number) {
                    resultsArray.append(match)
                }
            }

            return resultsArray

        } catch {
            return []
        }
    }
}
