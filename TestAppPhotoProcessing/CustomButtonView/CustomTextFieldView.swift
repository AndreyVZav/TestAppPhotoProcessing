//
//  CustomTextFieldView.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 19.03.2025.
//

import SwiftUI

struct CustomTextFieldView: View{
    @Binding var credentials: String
    @State var isSecureEntry: Bool = true
    var color: Color
    var textFieldTitle: String
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    var body: some View{
        VStack{
            
            HStack{
                if isSecure{
                    if isSecureEntry {
                    
                    SecureField(textFieldTitle,text: $credentials)
                        .foregroundColor(.mainBlack)
                        .textInputAutocapitalization(.never)
                    
                    
                } else {
                    
                    TextField(textFieldTitle,text: $credentials)
                        .foregroundColor(.mainBlack)
                        .textContentType(.emailAddress)
                        .textInputAutocapitalization(.never)
                }
                Button(action:{
                    isSecureEntry.toggle()
                })
                {
                    Image(systemName: isSecureEntry ?"eye.slash" : "eye")
                        .frame(width: 16, height: 16)
                        .foregroundColor(.mainBlack)
                        .padding(.trailing,20)
                }
            } else {
                TextField(textFieldTitle,text: $credentials)
                    .foregroundColor(.mainBlack)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
            }
            }
            .padding(.leading,20)
            .frame(width:335,height: 53)
            .background(color)
            .cornerRadius(60)
        }
    }
}
#Preview{
    CustomTextFieldView(credentials: .constant(""), color: .textField, textFieldTitle: Constants.email)
}
