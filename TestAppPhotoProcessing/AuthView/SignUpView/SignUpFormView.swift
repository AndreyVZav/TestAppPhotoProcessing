//
//  SignUpFormView.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 20.03.2025.
//
import SwiftUI

struct SignUpFormView: View {
    @ObservedObject var viewModel: SignUpViewModel
    let geometry: GeometryProxy
    
    var body: some View {
        VStack {
            VStack {
                CustomTextFieldView(
                    credentials: $viewModel.email,
                    color: .textField,
                    textFieldTitle: "Email",
                    isSecure: false
                )
                CustomTextFieldView(
                    credentials: $viewModel.password,
                    color: .textField,
                    textFieldTitle: "Password",
                    isSecure: true
                )
            }
            .padding(.bottom, geometry.size.height * 0.1)
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
            }
            
            CustomButtonView(title: "Done") {
                Task {
                    await viewModel.signUp(email: viewModel.email, password: viewModel.password) { _ in }
                }
            }
            
            Button(action: {
                viewModel.onCancelTapped?()
            }) {
                Text("Cancel")
                    .applyFont(.nunitoSans, .light, 15)
                    .foregroundColor(.mainBlack)
            }
            .padding(.top, geometry.size.height * 0.05)
        }
        .frame(width: geometry.size.width * 0.85)
    }
}

