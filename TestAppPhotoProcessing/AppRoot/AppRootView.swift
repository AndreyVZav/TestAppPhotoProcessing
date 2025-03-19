//
//  AppRootView.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 19.03.2025.
//
import SwiftUI

struct AppRootView: View {
    @State private var isAuthenticated = false
    
    var body: some View {
        NavigationStack {
            if isAuthenticated {
                ImageEditorView()
            } else {
                AuthContainerView(onAuthSuccess: {
                    isAuthenticated = true
                })
            }
        }
    }
}

