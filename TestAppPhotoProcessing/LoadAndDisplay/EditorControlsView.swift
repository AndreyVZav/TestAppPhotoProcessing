//
//  EditorControlsView.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 20.03.2025.
//
import SwiftUI
import PencilKit

struct EditorControlsView: View {
    @Binding var sourceType: UIImagePickerController.SourceType
    @Binding var showImagePicker: Bool
    @Binding var showDrawing: Bool
    
    let saveAction: () -> Void
    let undoAction: () -> Void
    let exitAction: () -> Void
    
    var body: some View {
        VStack {
            HStack(spacing: 16) {
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
            }
            
            Button {
                saveAction()
            } label: {
                Label("Save", systemImage: "square.and.arrow.down")
            }
            
            Button("Undo", action: undoAction)
            
            Button("Выход", action: exitAction)
                                .foregroundColor(.red)
            
        }
        .buttonStyle(.borderedProminent)
    }
}

