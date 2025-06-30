//
//  File name: NavigationCoordinator.swift
//  Project name: api-request-example-ios
//  Workspace name: api-request-example-ios
//
//  Created by: nothing-to-add on 30/06/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import Foundation
import SwiftUI

@MainActor
class NavigationCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    func navigate(to destination: NavigationDestination) {
        path.append(destination)
    }
    
    func navigateBack() {
        path.removeLast()
    }
    
    func navigateToRoot() {
        path.removeLast(path.count)
    }
    
    @ViewBuilder
    func view(for destination: NavigationDestination) -> some View {
        switch destination {
        case .defaultView:
            DefaultView()
        case .imageFetcher:
            ImageFetcherView()
        case .apiRequestHistory:
            APIRequestHistoryView()
        case .uikitExample:
            UIKitExampleContentView()
        case .swiftUIExample:
            SwiftUIExampleView()
        }
    }
}
