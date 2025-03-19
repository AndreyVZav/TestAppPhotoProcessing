//
//  SignUpView.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 19.03.2025.
//

import SwiftUI

struct SignUpView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var authSuccess: Bool = false
    @State private var errorMessage: String? = nil
    
    var viewModel: SignUpViewModelDelegate?
    var onSignUpSuccess: (() -> Void)?
    var onCancelTapped: (() -> Void)?
    
    var title = ""//

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    Image(ImageName.grayBubble)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .rotationEffect(.degrees(10 * 5.5))
                        .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.42)
                        .offset(y: -geometry.size.height * 0.2)
                        .offset(x: -geometry.size.width * 0.3)

                    Text(Constants.signUp)
                        .applyFont(.raleway, .bold, 50)
                        .foregroundColor(.mainBlack)
                        .padding(.bottom, geometry.size.height * 0.2)
                        .padding(.trailing, geometry.size.width * 0.3)

                    Image(ImageName.signUpBlueBubble)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.6, height: geometry.size.height * 0.25)
                        .offset(y: -geometry.size.height * 0.10)
                        .offset(x: geometry.size.width * 0.43)
                }
                
                VStack {
                    VStack {
                        CustomTextFieldView(credentials: $email, color: .textField, textFieldTitle: "Email", isSecure: false)
                        CustomTextFieldView(credentials: $password, color: .textField, textFieldTitle: "Password", isSecure: true)
                    }
                    .padding(.bottom, geometry.size.height * 0.1)

                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                    }

                    CustomButtonView(title: "Done", action: {
                        Task {
                            await signUpUser()
                        }
                    })

                    Button(action: {
                        onCancelTapped?()
                    }) {
                        Text("Cancel")
                            .applyFont(.nunitoSans, .light, 15)
                            .foregroundColor(.mainBlack)
                    }
                    .padding(.top, geometry.size.height * 0.05)
                }
                .frame(width: geometry.size.width * 0.85)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
    
    private func signUpUser() async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Email and password cannot be empty."
            return
        }
        errorMessage = nil
        
        await viewModel?.signUp(email: email, password: password, completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    authSuccess = true
                    onSignUpSuccess?()
                    print("Sign-Up Successful")
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
    SignUpView()
}
