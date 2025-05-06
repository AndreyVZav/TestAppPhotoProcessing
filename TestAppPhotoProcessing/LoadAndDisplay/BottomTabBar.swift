//
//  BottomTabBar.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 25.04.2025.
//
import SwiftUI

struct BottomTabBar: View {
    @ObservedObject var viewModel: ImageEditorViewModel
    let imageScale: CGFloat
    let imageRotation: Angle
    
    var body: some View {
        HStack {
    
            Button(action: {
                viewModel.tapPhotoLibrary()
            }) {
                Image(systemName: "photo.on.rectangle")
            }
            .frame(maxWidth: .infinity)
            
            Button(action: {
                viewModel.tapCamera()
            }) {
                Image(systemName: "camera")
            }
            .frame(maxWidth: .infinity)
            
            Button(action: {
                viewModel.toggleDrawing()
            }) {
                Image(systemName: "pencil.tip")
            }
            .frame(maxWidth: .infinity)
            
            Button(action: {
                viewModel.saveAction(scale: imageScale, rotation: imageRotation)
            }) {
                Image(systemName: "square.and.arrow.down")
            }
            .frame(maxWidth: .infinity)
            
            Button(action: {
                viewModel.undoAction()
            }) {
                Image(systemName: "arrow.uturn.backward")
            }
            .frame(maxWidth: .infinity)
            
            Button(action: {
                viewModel.clearAll()
            }) {
                Image(systemName: "xmark.circle")
                    .foregroundColor(.red)
            }
            .frame(maxWidth: .infinity)
            
            Button(action: {
                viewModel.tapExport()
            }) {
                Image(systemName: "square.and.arrow.up")
            }
            .disabled(viewModel.filteredImage == nil && viewModel.selectedImage == nil)
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
