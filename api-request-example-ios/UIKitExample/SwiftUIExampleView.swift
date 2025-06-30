//
//  File name: SwiftUIExampleView.swift
//  Project name: api-request-example-ios
//  Workspace name: api-request-example-ios
//
//  Created by: nothing-to-add on 30/06/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import SwiftUI

struct SwiftUIExampleView: View {
    var onDismiss: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "swift")
                .font(.system(size: 80))
                .foregroundColor(.orange)
            
            Text("SwiftUI Example View")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text("You successfully navigated from UIKit to SwiftUI!")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Close SwiftUI View") {
                onDismiss?()
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .background(Color.red)
            .cornerRadius(10)
            
            Spacer()
        }
        .padding()
        .navigationTitle("SwiftUI View")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    onDismiss?()
                }
            }
        }
    }
}

#Preview {
    SwiftUIExampleView(onDismiss: {
        print("Preview dismiss action")
    })
}
