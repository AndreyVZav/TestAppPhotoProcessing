//
//  BottomTabBar.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 25.04.2025.
//
import SwiftUI

struct BottomTabBar: View {
    @ObservedObject var viewModel: ImageEditorViewModel
    var saveAction: () -> Void
    var undoAction: () -> Void
    
    var body: some View {
        HStack {
    
            Button(action: {
                viewModel.sourceType = .photoLibrary
                viewModel.showImagePicker = true
            }) {
                Image(systemName: "photo.on.rectangle")
            }
            
            Button(action: {
                viewModel.sourceType = .camera
                viewModel.showImagePicker = true
            }) {
                Image(systemName: "camera")
            }
            
            Button(action: {
                viewModel.showDrawing.toggle()
            }) {
                Image(systemName: "pencil.tip")
            }
            
            Button(action: {
                saveAction()
            }) {
                Image(systemName: "square.and.arrow.down")
            }
            
            Button(action: {
                undoAction()
            }) {
                Image(systemName: "arrow.uturn.backward")
            }
            
            Button(action: {
                viewModel.exitApp()
            }) {
                Image(systemName: "xmark.circle")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(radius: 10)
        .padding(.horizontal)
    }
}
