//
//  Fonts.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 19.03.2025.
//

import SwiftUI

enum FontWeight {
    case light
    case regular
    case medium
    case semiBold
    case bold
    case extraBold
}

// Define names
enum FontFamily: String {
    case raleway = "Raleway"
    case poppins = "Poppins"
    case inter = "Inter"
    case nunitoSans = "NunitoSans_10pt"
}

// MainFunction
extension Font {
    static func customFont(_ family: FontFamily, _ fontWeight: FontWeight, _ size: CGFloat) -> Font {
        let fontName: String
        
        switch fontWeight {
        case .light:
            fontName = "\(family.rawValue)-Light"
        case .regular:
            fontName = "\(family.rawValue)-Regular"
        case .medium:
            fontName = "\(family.rawValue)-Medium"
        case .semiBold:
            fontName = "\(family.rawValue)-SemiBold"
        case .bold:
            fontName = "\(family.rawValue)-Bold"
        case .extraBold:
            fontName = "\(family.rawValue)-ExtraBold"
        }
        
        return Font.custom(fontName, size: size)
    }
}

// Extension For Text
extension Text {
    func applyFont(_ family: FontFamily, _ fontWeight: FontWeight? = .regular, _ size: CGFloat? = nil) -> Text {
        return self.font(.customFont(family, fontWeight ?? .regular, size ?? 16))
    }
}

// Extension for TextField
extension View {
    func applyFont(_ family: FontFamily, _ fontWeight: FontWeight? = .regular, _ size: CGFloat? = nil) -> some View {
        self.font(.customFont(family, fontWeight ?? .regular, size ?? 16))
    }
}
