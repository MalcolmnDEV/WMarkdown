//
//  MarkType.swift
//  WMarkdown
//
//  Created by Malcolmn Roberts on 2023/06/19.
//

import Foundation

enum MarkElement {
    case email(String)
    case phone(String)
    case url(original: String, trimmed: String)
    case sms(String)
    case emergency(String)

    static func create(with type: MarkType, text: String) -> MarkElement {
        switch type {
        case .email: return email(text)
        case .phone: return phone(text)
        case .url: return url(original: text, trimmed: text)
        case .sms: return sms(text)
        case .emergency: return emergency(text)
        }
    }

    var text: String {
        switch self {
        case .email(let text):
            return text
        case .phone(let text):
            return text
        case .url(original: _, trimmed: let trimmed):
            return trimmed
        case .sms(let text):
            return text
        case .emergency(let text):
            return text
        }
    }
}

public enum MarkType: CaseIterable {
    case url
    case email
    case phone
    case sms
    case emergency

    var pattern: String {
        switch self {
        case .url: return MarkRegex.urlPattern
        case .email: return MarkRegex.emailPattern
        case .phone: return MarkRegex.phonePattern
        case .sms: return MarkRegex.smsPattern
        case .emergency: return MarkRegex.emergencyPattern
        }
    }

    var action: String {
        switch self {
        case .url: return ""
        case .email: return "mailto:"
        case .phone: return "tel:"
        case .sms: return "sms:"
        case .emergency: return "tel:"
        }
    }
}

extension MarkType: Hashable, Equatable {
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .url: hasher.combine(-3)
        case .email: hasher.combine(-4)
        case .phone: hasher.combine(-5)
        case .sms: hasher.combine(-6)
        case .emergency: hasher.combine(-7)
        }
    }
}

public func ==(lhs: MarkType, rhs: MarkType) -> Bool {
    switch (lhs, rhs) {
    case (.url, .url): return true
    case (.email, .email): return true
    case (.phone, .phone): return true
    case (.sms, .sms): return true
    case (.emergency, .emergency): return true
    default: return false
    }
}
