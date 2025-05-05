//
//  MainLoginContent.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 20.03.2025.
//
import SwiftUI

struct MainLoginContent: View {
    @ObservedObject var viewModel: LoginViewModel
    let geometry: GeometryProxy
    
    var body: some View {
        let width = geometry.size.width
        let height = geometry.size.height
        
        VStack(alignment: .leading) {
            HeaderSection(width: width, height: height)
            
            CustomTextFieldView(
                credentials: $viewModel.email,
                color: .textField,
                textFieldTitle: "Email",
                isSecure: false
            )
            .padding(.bottom, viewModel.email.isEmpty ? height * 0.05 : height * 0.02)
            
            if !viewModel.email.isEmpty {
                CustomTextFieldView(
                    credentials: $viewModel.password,
                    color: .textField,
                    textFieldTitle: "Password",
                    isSecure: true
                )
                .padding(.bottom, height * 0.03)
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
            
            ActionButtons(viewModel: viewModel, height: height)
            
            
            
            
           
        }
        .frame(width: width)
    }
}

