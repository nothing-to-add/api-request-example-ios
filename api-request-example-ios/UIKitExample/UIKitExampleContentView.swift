//
//  File name: UIKitExampleContentView.swift
//  Project name: api-request-example-ios
//  Workspace name: api-request-example-ios
//
//  Created by: nothing-to-add on 30/06/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import SwiftUI

struct UIKitExampleContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("UIKit Example Content View")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            UIKitButtonWrapper()
                .frame(height: 44)
                .frame(maxWidth: 250)
        }
        .padding()
    }
}

#Preview {
    UIKitExampleContentView()
}
