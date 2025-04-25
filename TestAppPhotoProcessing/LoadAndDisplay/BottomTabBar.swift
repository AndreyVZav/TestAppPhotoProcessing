//
//  BottomTabBar.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 25.04.2025.
//
import SwiftUI

struct BottomTabBar: View {
    @Binding var sourceType: UIImagePickerController.SourceType
    @Binding var showImagePicker: Bool
    @Binding var showDrawing: Bool
    
    var saveAction: () -> Void
    var undoAction: () -> Void
    var exitAction: () -> Void
    
    var body: some View {
        TabView {
            Button {
                sourceType = .photoLibrary
                showImagePicker = true
            } label: {
                Image(systemName: "photo.on.rectangle")
            }
            .tabItem {
                Image(systemName: "photo.on.rectangle")
            }
            
            Button {
                sourceType = .camera
                showImagePicker = true
            } label: {
                Image(systemName: "camera")
            }
            .tabItem {
                Image(systemName: "camera")
            }
            
            Button {
                showDrawing.toggle()
            } label: {
                Image(systemName: "pencil.tip")
            }
            .tabItem {
                Image(systemName: "pencil.tip")
            }
            
            Button {
                saveAction()
            } label: {
                Image(systemName: "square.and.arrow.down")
            }
            .tabItem {
                Image(systemName: "square.and.arrow.down")
            }
            
            Button {
                undoAction()
            } label: {
                Image(systemName: "arrow.uturn.backward")
            }
            .tabItem {
                Image(systemName: "arrow.uturn.backward")
            }
            
            Button {
                exitAction()
            } label: {
                Image(systemName: "xmark.circle")
            }
            .tabItem {
                Image(systemName: "xmark.circle")
            }
        }
    }
}
