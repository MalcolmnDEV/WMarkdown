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
}
