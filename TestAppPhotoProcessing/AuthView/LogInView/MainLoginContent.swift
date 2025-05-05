//
//  MainLoginContent.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 20.03.2025.
//
import SwiftUI

struct MainLoginContent: View {
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HeaderSection(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            
            CustomTextFieldView(
                credentials: $viewModel.email,
                color: .textField,
                textFieldTitle: "Email",
                isSecure: false
            )
            .padding(.bottom, viewModel.email.isEmpty ? 30 : 12)
            
            if !viewModel.email.isEmpty {
                CustomTextFieldView(
                    credentials: $viewModel.password,
                    color: .textField,
                    textFieldTitle: "Password",
                    isSecure: true
                )
                .padding(.bottom, 20)
            }
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding(.bottom, 10)
            }
            
            HStack {
                Toggle(isOn: $viewModel.shouldRememberMe) {}
                    .labelsHidden()
                    .tint(.yellow)
                    .padding(.trailing)
                
                Text("remember Me")
                    .applyFont(.inter , .regular, 14)
                    .foregroundColor(.black)
            }
            
            ActionButtons(viewModel: viewModel, height: 200)
            
            
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
    }
}

