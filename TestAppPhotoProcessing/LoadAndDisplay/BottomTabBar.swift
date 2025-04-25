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
            .frame(maxWidth: .infinity)
            
            Button(action: {
                viewModel.sourceType = .camera
                viewModel.showImagePicker = true
            }) {
                Image(systemName: "camera")
            }
            .frame(maxWidth: .infinity)
            
            Button(action: {
                viewModel.showDrawing.toggle()
            }) {
                Image(systemName: "pencil.tip")
            }
            .frame(maxWidth: .infinity)
            
            Button(action: {
                saveAction()
            }) {
                Image(systemName: "square.and.arrow.down")
            }
            .frame(maxWidth: .infinity)
            
            Button(action: {
                undoAction()
            }) {
                Image(systemName: "arrow.uturn.backward")
            }
            .frame(maxWidth: .infinity)
            
            Button(action: {
                viewModel.exitApp()
            }) {
                Image(systemName: "xmark.circle")
                    .foregroundColor(.red)
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(radius: 10)
        .padding(.horizontal)
    }
}
