//
//  EditorControlsView.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 20.03.2025.
//
import SwiftUI

struct EditorControlsView: View {
    @Binding var sourceType: UIImagePickerController.SourceType
    @Binding var showImagePicker: Bool
    @Binding var showDrawing: Bool
    
    let saveAction: () -> Void
    
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
        }
        .buttonStyle(.borderedProminent)
    }
}

