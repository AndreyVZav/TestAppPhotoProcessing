//
//  HeaderSection.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 20.03.2025.
//
import SwiftUI

struct HeaderSection: View {
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
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
    }
}

