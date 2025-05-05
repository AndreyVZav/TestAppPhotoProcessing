//
//  ImageEditorView.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 19.03.2025.
//
import SwiftUI
import PencilKit

struct ImageEditorView: View {
    @ObservedObject var viewModel: ImageEditorViewModel
    @StateObject private var textVM = TextEditorViewModel()
    @State private var selectedTextID: UUID?
    
    let geometry: GeometryProxy
    
    // 🔧 Добавлено масштабирование и поворот изображения
    @State private var imageScale: CGFloat = 1.0
    @GestureState private var currentMagnification: CGFloat = 1.0
    
    @State private var imageRotation: Angle = .zero
    @GestureState private var currentRotation: Angle = .zero
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Photo Editor")
                .font(.largeTitle)
                .bold()
                .padding(.top)
            
            
            
            ZStack {
                if let image = viewModel.filteredImage ?? viewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: geometry.size.height * 0.6)
                        .scaleEffect(imageScale * currentMagnification) // 🔧 масштаб
                        .rotationEffect(imageRotation + currentRotation) // 🔧 поворот
                        .gesture(
                            SimultaneousGesture(
                                MagnificationGesture()
                                    .updating($currentMagnification) { value, state, _ in
                                        state = value
                                    }
                                    .onEnded { value in
                                        imageScale *= value
                                    },
                                
                                RotationGesture()
                                    .updating($currentRotation) { value, state, _ in
                                        state = value
                                    }
                                    .onEnded { value in
                                        imageRotation += value
                                    }
                            )
                        )
                        .cornerRadius(16)
                        .shadow(radius: 8)
                    
                    
                }
                
                
                
                if viewModel.showDrawing {
                    DrawingCanvasView(canvasView: $viewModel.canvasView)
                        .frame(height: geometry.size.height * 0.6)
                        .cornerRadius(16)
                        .shadow(radius: 8)
                        
                }
                
                ForEach($textVM.textOverlays) { $overlay in
                    EditableTextOverlayView(overlay: $overlay)
                        .onTapGesture {
                            selectedTextID = overlay.id
                        }
                }
                
            }
            .overlay(alignment: .bottom) {
                VStack(spacing: 12) {
                    Button("Добавить текст") {
                        let newOverlay = textVM.addTextOverlay()
                        viewModel.actionsStack.append(.text(newOverlay.id))
                    }
                    
                    Button("Выбрать фильтр") {
                        viewModel.isShowFilter = true
                    }
                    
                    if viewModel.isShowFilter {
                        FilterControlsView(
                            inputImage: $viewModel.selectedImage,
                            filteredImage: $viewModel.filteredImage,
                            isVisible: $viewModel.isShowFilter
                        )
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
            
            Spacer()
            
            BottomTabBar(
                viewModel: viewModel,
                saveAction: {
                    viewModel.saveEditedImage(
                        textOverlays: textVM.textOverlays,
                        scale: imageScale,
                        rotation: imageRotation + currentRotation
                    )
                },
                undoAction: { viewModel.undoLastAction(textVM: textVM) }
            )
            .frame(maxWidth: .infinity , minHeight: 70)
            
        }
        .fullScreenCover(isPresented: $viewModel.showImagePicker) {
            ImagePicker(selectedImage: $viewModel.selectedImage, sourceType: viewModel.sourceType)
        }
        .sheet(isPresented: $viewModel.showExportSheet) {
            if let imageToExport = viewModel.filteredImage ?? viewModel.selectedImage {
                ImageExportView(image: imageToExport)
            }
        }
        .alert(isPresented: $viewModel.showSaveAlert) {
            Alert(
                title: Text(viewModel.saveSuccess ? "Saved!" : "Error"),
                message: Text(viewModel.saveSuccess ? "Image saved to Photos." : "Failed to save image."),
                dismissButton: .default(Text("OK"))
            )
        }
        .padding()
    }
    
}


struct ImageEditorView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            ImageEditorView(
                viewModel: ImageEditorViewModel(),
                geometry: geometry
            )
        }
    }
}

