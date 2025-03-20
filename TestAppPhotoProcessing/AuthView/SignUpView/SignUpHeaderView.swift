//
//  SignUpHeaderView.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 20.03.2025.
//
import SwiftUI

struct SignUpHeaderView: View {
    let geometry: GeometryProxy
    
    var body: some View {
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
    }
}

