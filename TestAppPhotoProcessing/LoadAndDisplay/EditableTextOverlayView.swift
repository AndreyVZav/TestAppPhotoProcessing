//
//  EditableTextOverlayView.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 21.03.2025.
//
import SwiftUI

struct EditableTextOverlayView: View {
    @Binding var overlay: TextOverlay
    @GestureState private var dragOffset = CGSize.zero
    
    var body: some View {
        Text(overlay.text)
            .font(.custom(overlay.fontName, size: overlay.fontSize))
            .foregroundColor(overlay.textColor)
            .position(x: overlay.position.x + dragOffset.width,
                      y: overlay.position.y + dragOffset.height)
            .gesture(
                DragGesture()
                    .updating($dragOffset) { value, state, _ in
                        state = value.translation
                    }
                    .onEnded { value in
                        overlay.position.x += value.translation.width
                        overlay.position.y += value.translation.height
                    }
            )
    }
}
