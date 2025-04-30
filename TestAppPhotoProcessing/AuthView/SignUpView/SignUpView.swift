//
//  SignUpView.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 19.03.2025.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var viewModel: SignUpViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                SignUpHeaderView(geometry: geometry)
                SignUpFormView(viewModel: viewModel, geometry: geometry)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .alert("Registration successful!", isPresented: $viewModel.showSuccessAlert) {
                Button("OK") {
                        viewModel.onCancelTapped?() 
                    }
            }
        }
    }
    
}

#Preview {
    SignUpView(viewModel: SignUpViewModel(Dependencies.shared))
}
