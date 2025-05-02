//
//  ImageExportView.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 01.05.2025.
//

import SwiftUI

struct ImageExportView: UIViewControllerRepresentable {
    let image: UIImage
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        return activityVC
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
