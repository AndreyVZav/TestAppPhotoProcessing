//
//  CustomButtonView.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 19.03.2025.
//

import SwiftUI
struct CustomButtonView:View{
    var title:String
    var action:()->Void
    var body: some View{
        HStack{
            Button(action: action){
                Text(title)
                    .applyFont(.nunitoSans, .light,22)
                    .foregroundColor(.startButtonTitle)
            }
            
        }
        .frame(width:335,height: 61)
        .background(Color.mainBlue)
        .cornerRadius(16)
    }
}

#Preview {
    CustomButtonView(title: "Let's get started", action: {})
}
