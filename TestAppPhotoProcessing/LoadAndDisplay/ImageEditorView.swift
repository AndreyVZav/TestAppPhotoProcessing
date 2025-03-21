//
//  ImageEditorView.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 19.03.2025.
//
import SwiftUI
import PencilKit

struct ImageEditorView: View {
    @State private var drawingUndoStack: [PKDrawing] = []
    
    @StateObject private var textVM = TextEditorViewModel()
    @State private var selectedTextID: UUID?
    
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    // Жесты
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    
    @State private var rotation: Angle = .zero
    @State private var lastRotation: Angle = .zero
    
    // PencilKit
    @State private var canvasView = PKCanvasView()
    @State private var showDrawing = false
    
    @State private var showSaveAlert = false
    @State private var saveSuccess = false
    
    let geometry: GeometryProxy
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Photo Editor")
                .font(.largeTitle)
                .bold()
            
            ZStack {
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: geometry.size.height * 0.6)
                        .scaleEffect(scale)
                        .rotationEffect(rotation)
                        .gesture(
                            SimultaneousGesture(
                                MagnificationGesture()
                                    .onChanged { value in
                                        scale = lastScale * value
                                    }
                                    .onEnded { _ in
                                        lastScale = scale
                                    },
                                RotationGesture()
                                    .onChanged { value in
                                        rotation = lastRotation + value
                                    }
                                    .onEnded { _ in
                                        lastRotation = rotation
                                    }
                            )
                        )
                        .cornerRadius(16)
                        .shadow(radius: 8)
                }
                
                if showDrawing {
                    DrawingCanvasView(canvasView: $canvasView)
                        .frame(height: geometry.size.height * 0.6)
                        .cornerRadius(16)
                        .shadow(radius: 8)
                        .onChange(of: canvasView.drawing) {_, newDrawing in
                            drawingUndoStack.append(newDrawing)
                        }
                }
                
                ForEach($textVM.textOverlays) { $overlay in
                    EditableTextOverlayView(overlay: $overlay)
                        .onTapGesture {
                            selectedTextID = overlay.id
                        }
                }
                
            }
            .overlay(alignment: .bottom) {
                VStack(spacing: 8) {
                    Button("Добавить текст") {
                        textVM.addTextOverlay()
                    }
                    if let id = selectedTextID,
                       let index = textVM.textOverlays.firstIndex(where: { $0.id == id }) {
                        TextEditorControlsView(
                            selectedText: $textVM.textOverlays[index],
                            selectedTextID: $selectedTextID
                        )
                    }
                }
                .padding()
            }
            
            EditorControlsView(
                sourceType: $sourceType,
                showImagePicker: $showImagePicker,
                showDrawing: $showDrawing,
                saveAction: saveEditedImage,
                undoAction: undoLastAction,
                exitAction: exitApp
            )
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage, sourceType: sourceType)
        }
        .alert(isPresented: $showSaveAlert) {
            Alert(
                title: Text(saveSuccess ? "Saved!" : "Error"),
                message: Text(saveSuccess ? "Image saved to Photos." : "Failed to save image."),
                dismissButton: .default(Text("OK"))
            )
        }
        .padding()
    }
    
    private func undoLastAction() {
        canvasView.drawing = PKDrawing()
        drawingUndoStack = [canvasView.drawing]
    }
    
    private func exitApp() {
        exit(0)
    }
    
    // сохранение изображения
    private func saveEditedImage() {
        guard let baseImage = selectedImage else { return }
        
        // объединяем рисунок и изображение
        let size = baseImage.size
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        baseImage.draw(in: CGRect(origin: .zero, size: size))
        
        // масштабируем canvas
        let drawing = canvasView.drawing.image(from: canvasView.bounds, scale: 1.0)
        drawing.draw(in: CGRect(origin: .zero, size: size))
        
        // Текстовые слои
        for overlay in textVM.textOverlays {
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
