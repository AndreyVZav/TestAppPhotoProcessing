//
//  LoginView.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 19.03.2025.
//

import SwiftUI
import GoogleSignInSwift

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                BackgroundDecorations(geometry: geometry)
                
            }
            HStack(alignment:.bottom) {
                MainLoginContent(viewModel: viewModel, geometry: geometry)
            }
            
        }
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel(Dependencies.shared))
}
