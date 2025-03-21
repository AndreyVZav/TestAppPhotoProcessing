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
            NavigationStack {
                if viewModel.isAuthenticated {
                    ImageEditorView(geometry: geometry)
                } else {
                    AuthContainerView(viewModel: viewModel.authContainerViewModel)
                }
            }
        }
    }
}

