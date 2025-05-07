//
//  UIApplication.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 07.05.2025.
//
import UIKit

extension UIApplication {
    static var rootViewController: UIViewController? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?
            .windows
            .first(where: \.isKeyWindow)?
            .rootViewController
    }
}
