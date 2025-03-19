//
//  ImageEditorView.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 19.03.2025.
//
import SwiftUI
import PhotosUI
import PencilKit

struct DrawingCanvasView: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.drawingPolicy = .anyInput
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {}
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
        ) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}


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
                        .frame(height: 300)
                        .scaleEffect(scale)
                        .rotationEffect(rotation)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    scale = lastScale * value
                                }
                                .onEnded { _ in
                                    lastScale = scale
                                }
                        )
                        .gesture(
                            RotationGesture()
                                .onChanged { angle in
                                    rotation = lastRotation + angle
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
                        .frame(height: 300)
                        .cornerRadius(16)
                        .shadow(radius: 8)
                        .allowsHitTesting(true)
                }
            }
            
            VStack(spacing: 16) {
                Button {
                    sourceType = .photoLibrary
                    showImagePicker = true
                } label: {
                    Label("Gallery", systemImage: "photo.on.rectangle")
                }
                
                Button {
                    sourceType = .camera
                    showImagePicker = true
                } label: {
                    Label("Camera", systemImage: "camera")
                }
                
                Button {
                    showDrawing.toggle()
                } label: {
                    Label(showDrawing ? "Photo" : "Draw", systemImage: "pencil.tip")
                }
                
                Button {
                    saveEditedImage()
                } label: {
                    Label("Save", systemImage: "square.and.arrow.down")
                }
            }
            .buttonStyle(.borderedProminent)
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
        
        // Объединяем рисунок и изображение
        let size = baseImage.size
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        baseImage.draw(in: CGRect(origin: .zero, size: size))
        
        // Масштабируем canvas
        let drawing = canvasView.drawing.image(from: canvasView.bounds, scale: 1.0)
        drawing.draw(in: CGRect(origin: .zero, size: size))
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let finalImage = finalImage else {
            saveSuccess = false
            showSaveAlert = true
            return
        }
        
        // Сохраняем в фотопоток
        UIImageWriteToSavedPhotosAlbum(finalImage, nil, nil, nil)
        saveSuccess = true
        showSaveAlert = true
    }
}
