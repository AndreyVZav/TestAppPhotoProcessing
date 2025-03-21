//
//  TextOverlay.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 21.03.2025.
//

import SwiftUI

struct TextOverlay: Identifiable {
    let id = UUID()
    var text: String
    var fontSize: CGFloat
    var fontName: String
    var textColor: Color
    var position: CGPoint
}

extension TextOverlay {
    static let preview = TextOverlay(
        text: "Новый текст",
        fontSize: 24,
        fontName: "Helvetica",
        textColor: .white,
        position: CGPoint(x: 150, y: 150)
    )
}
