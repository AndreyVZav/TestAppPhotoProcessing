//
//  ImageEditorView.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 19.03.2025.
//
import SwiftUI
import PencilKit

struct ImageEditorView: View {
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
                            MagnificationGesture()
                                .onChanged {
                                    scale = lastScale * $0
                                }
                                .onEnded { _ in
                                    lastScale = scale
                                }
                        )
                        .gesture(
                            RotationGesture()
                                .onChanged {
                                    rotation = lastRotation + $0
                                }
                                .onEnded { _ in
                                    lastRotation = rotation
                                }
                        )
                        .cornerRadius(16)
                        .shadow(radius: 8)
                }
                
                if showDrawing {
                    DrawingCanvasView(canvasView: $canvasView)
                        .frame(height: geometry.size.height * 0.6)
                        .cornerRadius(16)
                        .shadow(radius: 8)
                }
            }
            
            EditorControlsView(
                sourceType: $sourceType,
                showImagePicker: $showImagePicker,
                showDrawing: $showDrawing,
                saveAction: saveEditedImage
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
    
    // 📸 Сохранение изображения
    private func saveEditedImage() {
        guard let baseImage = selectedImage else { return }
        
        // объединяем рисунок и изображение
        let size = baseImage.size
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        baseImage.draw(in: CGRect(origin: .zero, size: size))
        
        // масштабируем canvas
        let drawing = canvasView.drawing.image(from: canvasView.bounds, scale: 1.0)
        drawing.draw(in: CGRect(origin: .zero, size: size))
        
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
