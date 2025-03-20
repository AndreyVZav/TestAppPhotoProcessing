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
        NavigationStack {
            if viewModel.isAuthenticated {
                ImageEditorView()
            } else {
                AuthContainerView(viewModel: viewModel.authContainerViewModel)
            }
        }
    }
}

