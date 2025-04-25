//
//  ImageEditorViewModel.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 25.04.2025.
//
import SwiftUI
import PencilKit

class ImageEditorViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var showImagePicker = false
    @Published var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Published var showDrawing = false
    @Published var canvasView = PKCanvasView()
    @Published var drawingUndoStack: [PKDrawing] = []
    @Published var showSaveAlert = false
    @Published var saveSuccess = false
    @Published var actionsStack: [EditAction] = []
    
    enum EditAction {
        case drawing(PKDrawing)
        case text(UUID) // текстовое действие связано с id текста
    }
    
    
    
    func undoLastAction(textVM: TextEditorViewModel) {
        guard let lastAction = actionsStack.popLast() else { return }
        
        switch lastAction {
        case .drawing(let previousDrawing):
            canvasView.drawing = previousDrawing
        case .text(let textID):
            if let index = textVM.textOverlays.firstIndex(where: { $0.id == textID }) {
                textVM.textOverlays.remove(at: index)
            }
        }
    }
    
    func exitApp() {
        exit(0)
    }
    
    func saveEditedImage(textOverlays: [TextOverlay]) {
        guard let baseImage = selectedImage else { return }
        
        // объединяем рисунок и изображение
        let size = baseImage.size
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        baseImage.draw(in: CGRect(origin: .zero, size: size))
        
        // масштабируем canvas
        let drawing = canvasView.drawing.image(from: canvasView.bounds, scale: 1.0)
        drawing.draw(in: CGRect(origin: .zero, size: size))
        
        // Текстовые слои
        for overlay in textOverlays {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: overlay.fontName, size: overlay.fontSize) ?? UIFont.systemFont(ofSize: overlay.fontSize),
                .foregroundColor: UIColor(overlay.textColor)
            ]
            let attributedText = NSAttributedString(string: overlay.text, attributes: attributes)
            let textSize = attributedText.size()
            let position = overlay.position
            let textRect = CGRect(
                origin: CGPoint(x: position.x - textSize.width / 2, y: position.y - textSize.height / 2),
                size: textSize
            )
            attributedText.draw(in: textRect)
        }
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if finalImage != nil {
            UIImageWriteToSavedPhotosAlbum(finalImage!, nil, nil, nil)
            saveSuccess = true
        } else {
            saveSuccess = false
        }
        showSaveAlert = true
    }
}
