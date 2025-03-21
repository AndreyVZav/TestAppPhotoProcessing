//
//  TextEditorViewModel.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 21.03.2025.
//

import SwiftUI

class TextEditorViewModel: ObservableObject {
    @Published var textOverlays: [TextOverlay] = []
    
    func addTextOverlay() {
        let newText = TextOverlay(
            text: "Новый текст",
            fontSize: 24,
            fontName: "Helvetica",
            textColor: .white,
            position: CGPoint(x: 150, y: 150)
        )
        textOverlays.append(newText)
    }
    
    func updateText(_ overlay: TextOverlay, newText: String) {
        if let index = textOverlays.firstIndex(where: { $0.id == overlay.id }) {
            textOverlays[index].text = newText
        }
    }
}
