//
//  AppRootViewModel.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 20.03.2025.
//
import SwiftUI
import Combine

class AppRootViewModel: ObservableObject {
    @Published var isAuthenticated = false
    
    func setAuthenticated(_ isAuthenticated: Bool) {
        self.isAuthenticated = isAuthenticated
    }
}
