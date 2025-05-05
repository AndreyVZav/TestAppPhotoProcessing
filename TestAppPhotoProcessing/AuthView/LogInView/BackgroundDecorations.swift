//
//  BackgroundDecorations.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 20.03.2025.
//

import SwiftUICore

struct BackgroundDecorations: View {
    let geometry: GeometryProxy
    private var width: CGFloat { geometry.size.width }
    private var height: CGFloat { geometry.size.height }
    
    var body: some View {
        
        ZStack {
            Image(ImageName.grayLogBubble)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width * 0.8, height: height * 0.5)
                .offset(y: -height * 0.1)
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
            
            Image(ImageName.loginGrayBubble)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width * 0.85, height: height * 0.5)
                .offset(y: height * 0.6)
                .offset(x: width * 0.2)
        }
    }
}

