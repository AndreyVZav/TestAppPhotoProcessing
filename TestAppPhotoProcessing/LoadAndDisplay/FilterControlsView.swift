//
//  FilterControlsView.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 01.05.2025.
//
import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct FilterControlsView: View {
    @Binding var inputImage: UIImage?
    @Binding var filteredImage: UIImage?
    @Binding var isVisible: Bool
    
    private let context = CIContext()
    private let filters: [(name: String, filter: CIFilter)] = [
        ("Оригинал", CIFilter(name: "CIColorControls")!),
        ("Сепия", CIFilter.sepiaTone()),
        ("Noir", CIFilter.photoEffectNoir()),
        ("Инверт", CIFilter.colorInvert()),
        ("Моно", CIFilter.photoEffectMono()),
        ("Fade", CIFilter.photoEffectFade())
    ]
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Фильтр изображения")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(filters, id: \.name) { filterOption in
                        Button(filterOption.name) {
                            applyFilter(filterOption.filter)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                        .foregroundColor(.blue)
                    }
                }
            }
            
            Button("Закрыть") {
                isVisible = false
            }
            .foregroundColor(.blue)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(radius: 8)
        .frame(width: 300)
    }
    
    private func applyFilter(_ filter: CIFilter) {
        guard let inputImage = inputImage else { return }
        
        let beginImage = CIImage(image: inputImage)
        filter.setValue(beginImage, forKey: kCIInputImageKey)
        
        if let outputImage = filter.outputImage,
           let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            filteredImage = UIImage(cgImage: cgimg)
        }
    }
}

extension CIFilter {
    static func originalFilter() -> CIFilter {
        let filter = CIFilter(name: "CIColorControls")!
        filter.setValue(1.0, forKey: kCIInputSaturationKey)
        return filter
    }
}

