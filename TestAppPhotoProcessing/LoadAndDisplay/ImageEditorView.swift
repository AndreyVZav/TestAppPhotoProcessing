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
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Photo Editor")
                .font(.largeTitle)
                .bold()
            
            ZStack {
                if let image = viewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: geometry.size.height * 0.6)
                        .cornerRadius(16)
                        .shadow(radius: 8)
                }
                
                if viewModel.showDrawing {
                    DrawingCanvasView(canvasView: $viewModel.canvasView)
                        .frame(height: geometry.size.height * 0.6)
                        .cornerRadius(16)
                        .shadow(radius: 8)
                        .onChange(of: viewModel.canvasView.drawing) {_, newDrawing in
                            viewModel.drawingUndoStack.append(newDrawing)
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
            
            Spacer()
            
            BottomTabBar(
                viewModel: viewModel,
                saveAction: { viewModel.saveEditedImage(textOverlays: textVM.textOverlays) },
                undoAction: viewModel.undoLastAction,
            )
            .frame(height: 70)
        }
        .sheet(isPresented: $viewModel.showImagePicker) {
            ImagePicker(selectedImage: $viewModel.selectedImage, sourceType: viewModel.sourceType)
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

