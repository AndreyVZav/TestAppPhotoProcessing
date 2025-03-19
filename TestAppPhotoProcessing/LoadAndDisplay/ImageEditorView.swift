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
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Photo Editor")
                .font(.largeTitle)
                .bold()
            
            if showDrawing {
                DrawingCanvasView(canvasView: $canvasView)
                    .frame(height: 300)
                    .cornerRadius(16)
                    .shadow(radius: 8)
            } else if let image = selectedImage {
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
            } else {
                Text("No image selected")
                    .foregroundColor(.gray)
            }
            
            HStack(spacing: 16) {
                Button(action: {
                    sourceType = .photoLibrary
                    showImagePicker = true
                }) {
                    Label("Gallery", systemImage: "photo.on.rectangle")
                }
                
                Button(action: {
                    sourceType = .camera
                    showImagePicker = true
                }) {
                    Label("Camera", systemImage: "camera")
                }
                
                Button(action: {
                    showDrawing.toggle()
                }) {
                    Label(showDrawing ? "Photo" : "Draw", systemImage: "pencil.tip")
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage, sourceType: sourceType)
        }
        .padding()
    }
}
