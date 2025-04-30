//
//  ImageEditorViewModel.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 25.04.2025.
//
import SwiftUI
import PencilKit

class ImageEditorViewModel: NSObject, ObservableObject, PKCanvasViewDelegate {
    @Published var selectedImage: UIImage?
    @Published var showImagePicker = false
    @Published var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Published var showDrawing = false
    @Published var canvasView = PKCanvasView()
    @Published var drawingUndoStack: [PKDrawing] = []
    @Published var showSaveAlert = false
    @Published var saveSuccess = false
    @Published var actionsStack: [EditAction] = []
    @Published var previousDrawing: PKDrawing = PKDrawing()
    
    enum EditAction {
        case drawing(PKDrawing)
        case text(UUID) // текстовое действие связано с id текста
    }
    
    
    override init() {
        super.init()
        canvasView.delegate = self
    }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            guard showDrawing else { return }
            
            if canvasView.drawing != previousDrawing {
                // Сохраняем действие
                actionsStack.append(.drawing(previousDrawing))
                previousDrawing = canvasView.drawing
            }
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
    
    
    func saveEditedImage(textOverlays: [TextOverlay], scale: CGFloat, rotation: Angle) {
        guard let baseImage = selectedImage else { return }
        
        // объединяем рисунок и изображение
        let size = baseImage.size
        guard let context = createGraphicsContext(from: size) else { return }
        
        drawTransformedImage(baseImage, in: context, size: size, scale: scale, rotation: rotation)
        drawCanvasDrawing(in: context, size: size)
        drawTextOverlays(textOverlays, in: context)
        
        let finalImage = finalizeImageContext()
        
        if let image = finalImage {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            saveSuccess = true
        } else {
            saveSuccess = false
        }
        
        showSaveAlert = true
    }
    
    
    private func createGraphicsContext(from size: CGSize) -> CGContext? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        return UIGraphicsGetCurrentContext()
    }
    
    private func drawTransformedImage(_ image: UIImage, in context: CGContext, size: CGSize, scale: CGFloat, rotation: Angle) {
        
        // Применим масштаб и поворот
        context.saveGState()
        
        // Переместим начало координат в центр изображения (для поворота вокруг центра)
        context.translateBy(x: size.width / 2, y: size.height / 2)
        
        // Применим поворот (в радианах)
        context.rotate(by: CGFloat(rotation.radians))
        
        // Применим масштаб
        context.scaleBy(x: scale, y: scale)
        
        // Вернёмся к левому верхнему углу, чтобы нарисовать изображение от центра
        let imageRect = CGRect(
            x: -size.width / 2,
            y: -size.height / 2,
            width: size.width,
            height: size.height
        )
        image.draw(in: imageRect)
        context.restoreGState()
    }
    
    private func drawCanvasDrawing(in context: CGContext, size: CGSize) {
        // 🔴 Отрисовка рисунка (line drawing)
        let drawingImage = canvasView.drawing.image(from: canvasView.bounds, scale: 1.0)
        drawingImage.draw(in: CGRect(origin: .zero, size: size))
    }
    
    private func drawTextOverlays(_ overlays: [TextOverlay], in context: CGContext) {
        // 🔴 Отрисовка текста
        for overlay in overlays {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: overlay.fontName, size: overlay.fontSize) ?? UIFont.systemFont(ofSize: overlay.fontSize),
                .foregroundColor: UIColor(overlay.textColor)
            ]
            let attributedText = NSAttributedString(string: overlay.text, attributes: attributes)
            let textSize = attributedText.size()
            let textRect = CGRect(
                origin: CGPoint(x: overlay.position.x - textSize.width / 2, y: overlay.position.y - textSize.height / 2),
                size: textSize
            )
            attributedText.draw(in: textRect)
        }
    }
    
    private func finalizeImageContext() -> UIImage? {
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    
}
