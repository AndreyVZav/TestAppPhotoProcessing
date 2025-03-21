//
//  TextEditorControlsView.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 21.03.2025.
//
import SwiftUI

struct TextEditorControlsView: View {
    @Binding var selectedText: TextOverlay
    
    var body: some View {
        VStack(spacing: 12) {
            TextField("Введите текст", text: $selectedText.text)
                .textFieldStyle(.roundedBorder)
            
            Slider(value: $selectedText.fontSize, in: 10...72, step: 1) {
                Text("Размер шрифта")
            }
            
            ColorPicker("Цвет текста", selection: $selectedText.textColor)
            
            Picker("Шрифт", selection: $selectedText.fontName) {
                Text("Helvetica").tag("Helvetica")
                Text("Courier").tag("Courier")
                Text("Times New Roman").tag("Times New Roman")
            }
            .pickerStyle(.segmented)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
    }
}
