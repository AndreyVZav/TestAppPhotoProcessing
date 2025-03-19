//
//  LoginView.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 19.03.2025.
//

import SwiftUI

struct LoginView: View {
    var viewModel: LoginViewModelDelegate?
    var onLoginSuccess: (() -> Void)?
    var onCancelTapped: (() -> Void)?
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var authSuccess: Bool = false
    @State private var errorMessage: String?
    
    var title = ""
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            
            ZStack {
                Image(ImageName.grayLogBubble)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: width * 0.8, height: height * 0.5)
                    .offset(y: -height * 0.1 )
                    .offset(x: -width * 0.087)
                
                ZStack {
                    Image(ImageName.blueBuble)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: width * 0.85, height: height * 0.5)
                        .offset(y: -height * 0.18)
                        .offset(x: -width * 0.2)
                    
                    Image(ImageName.miniBlueBubble)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: width * 0.35, height: height * 0.2)
                        .offset(y: height * 0.09)
                        .offset(x: width * 0.5)
                }
            }
            
            VStack {
                ZStack {
                    Image(ImageName.loginGrayBubble)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: width * 0.85, height: height * 0.5)
                        .offset(y: height * 0.6)
                        .offset(x: width * 0.2)
                }
                
                VStack(alignment: .leading) {
                    Text(Constants.LogIn)
                        .applyFont(.raleway, .bold, 52)
                        .foregroundColor(.mainBlack)
                        .padding(.bottom, 5)
                    
                    HStack(spacing: 10) {
                        Text(Constants.LogInSubTitle)
                            .applyFont(.nunitoSans, .light, 19)
                            .foregroundColor(.mainBlack)
                        
                        Image(ImageName.heartIcon)
                    }
                }
                .padding(.trailing, width * 0.27)
                .padding(.bottom, height * 0.02)
                
                CustomTextFieldView(credentials: $email, color: .textField, textFieldTitle: "Email", isSecure: false)
                    .padding(.bottom, email.isEmpty ? height * 0.05 : height * 0.02)
                
                if !email.isEmpty {
                    CustomTextFieldView(credentials: $password, color: .textField, textFieldTitle: "Password", isSecure: true)
                        .padding(.bottom, height * 0.03)
                }
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.bottom, 10)
                }
                
                VStack(spacing: 14) {
                    CustomButtonView(title: "Next", action: {
                        loginUser()
                    })
                    
                    Button(action: {
                        onCancelTapped?()
                    }) {
                        Text("Cancel")
                            .applyFont(.nunitoSans, .light, 15)
                            .foregroundColor(.mainBlack)
                    }
                }
                .padding(.bottom, height * 0.3)
            }
            .frame(width: width)
        }
    }
    
    private func loginUser() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Email and password cannot be empty."
            return
        }
        
        errorMessage = nil
        
        viewModel?.login(email: email, password: password, completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    authSuccess = true
                    onLoginSuccess?()
                    print("Login Successful")
                case .failure(let error):
                    authSuccess = false
                    errorMessage = error.localizedDescription
                    print("Error: \(error.localizedDescription)")
                }
            }
        })
    }
}

#Preview {
    LoginView()
}
