//
//  WMLabel.swift
//  WMarkdown
//
//  Created by Malcolmn Roberts on 2024/07/19.
//

import UIKit
import SwiftUI

public class WMLabel: UILabel {
    private var hostingController: UIHostingController<WMLabelView>?

    public init (
        text: String,
        foregroundColor: UIColor,
        alignment: TextAlignment = .leading,
        backgroundColor: UIColor = .clear,
        tint: Color
    ) {
        super.init(frame: .zero)
        
        let markdownWithPrelim = text.markdownWithPrelim
        let overlayView = WMLabelView(
            text: markdownWithPrelim,
            foregroundColor: Color(uiColor: foregroundColor),
            alignment: alignment,
            backgroundColor: Color(uiColor: backgroundColor), 
            tint: tint
        )
        setupHostingController(with: overlayView)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupHostingController(with overlayView: WMLabelView) {
        // create a UIHostingController with the SwiftUI view
        hostingController = UIHostingController(rootView: overlayView)

        guard let hostingController = hostingController else { return }

        // add the hosting controller's view as a subview
        addSubview(hostingController.view)

        // setup constraints
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: self.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

fileprivate struct WMLabelView: View {
    var text: String
    var foregroundColor: Color
    var alignment: TextAlignment = .leading
    var backgroundColor: Color = .clear
    var tint: Color

    var body: some View {
        Text(.init(text))
            .padding()
            .multilineTextAlignment(alignment)
            .background(backgroundColor)
            .foregroundStyle(foregroundColor)
            .tint(tint)
            .cornerRadius(8)
    }
}

#Preview {
    WMLabelView(text: "Hello", foregroundColor: .red, tint: .green)
}
