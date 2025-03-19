//
//  generateID.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 19.03.2025.
//
import SwiftUI

func generateIntID(from uid: String) -> Int {
    let hashValue = uid.hashValue
    return abs(hashValue) // Ensure positive values
}
