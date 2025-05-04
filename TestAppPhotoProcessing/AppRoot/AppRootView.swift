//
//  AppRootView.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 19.03.2025.
//
import SwiftUI

struct AppRootView: View {
    @StateObject private var viewModel = AppRootViewModel()

    var body: some View {
        GeometryReader { geometry in
            
            if viewModel.isLoading {
                ZStack {
                    Color(.systemBackground).ignoresSafeArea()
                    ProgressView("Загрузка...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .font(.headline)
                }
            } else {
                
                NavigationStack {
                    if viewModel.isAuthenticated {
                        ImageEditorView(viewModel: viewModel.imageEditorViewModel, geometry: geometry)
                    } else {
                        AuthContainerView(viewModel: viewModel.authContainerViewModel)
                    }
                }
            }
        }
    }
}

