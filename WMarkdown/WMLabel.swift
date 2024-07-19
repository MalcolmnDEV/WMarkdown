//
//  WMLabel.swift
//  WMarkdown
//
//  Created by Malcolmn Roberts on 2024/07/19.
//

import UIKit
import SwiftUI

class WMLabel: UILabel {

    // MARK: - Initializations
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public init(
        frame: CGRect,
        text: String,
        foregroundColor: UIColor
    ) {
        super.init(frame: frame)
        setup(
            text: text,
            foregroundColor: foregroundColor
        )
    }

    private func setup(
        text: String,
        foregroundColor: UIColor
    ) {
        textAlignment = .center
        translatesAutoresizingMaskIntoConstraints = false

        addSwiftUIOverlay(
            text: text,
            foregroundColor: foregroundColor
        )
    }

    private func addSwiftUIOverlay(
        text: String,
        foregroundColor: UIColor
    ) {

        let markdownWithPrelim = text.markdownWithPrelim
        let overlayView = WMLabelView(
            text: markdownWithPrelim,
            foregroundColor: Color(uiColor: foregroundColor)
        )
        let hostingController = UIHostingController(rootView: overlayView)
        addSubview(hostingController.view)

        // ensure the SwiftUI view covers the UILabel
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

struct WMLabelView: View {
    var text: String
    var foregroundColor: Color
    var body: some View {
        Text(.init(text))
            .padding()
            .background(Color.clear)
            .foregroundStyle(foregroundColor)
    }
}

#Preview {
    WMLabelView(text: "Hello", foregroundColor: .red)
}
