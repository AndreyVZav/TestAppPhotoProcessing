//
//  ActionButtons.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 20.03.2025.
//
import SwiftUI

struct ActionButtons: View {
    let viewModel: LoginViewModel
    let height: CGFloat
    
    var body: some View {
        VStack(spacing: 14) {
            CustomButtonView(title: "Next", action: {
                viewModel.login(email: viewModel.email, password: viewModel.password) { result in
                    switch result {
                    case .success:
                        print("✅ Вход выполнен успешно!")
                    case .failure(let error):
                        print("❌ Ошибка входа: \(error.localizedDescription)")
                    }
                }
            })
            
            Button(action: {
                viewModel.onCancelTapped?()
            }) {
                Text(Constants.cancel)
                    .applyFont(.nunitoSans, .light, 15)
                    .foregroundColor(.mainBlack)
            }
        }
        .padding(.bottom, height * 0.3)
    }
}

