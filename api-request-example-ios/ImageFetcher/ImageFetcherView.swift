//
//  File name: ImageFetcherView.swift
//  Project name: api-request-example-ios
//  Workspace name: api-request-example-ios
//
//  Created by: nothing-to-add on 30/06/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import SwiftUI
import SwiftData

struct ImageFetcherView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: ImageFetcherViewModel
    @EnvironmentObject private var coordinator: NavigationCoordinator
    
    init() {
        self._viewModel = StateObject(wrappedValue: ImageFetcherViewModel())
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Random Dog Image Fetcher")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            // Explanation text about functionality
            VStack(spacing: 8) {
                Text("This view demonstrates image fetching capabilities")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Text("• Fetches random dog images from an API")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("• Displays loading states and error handling")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("• Saves image history using SwiftData")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
            
            // Image display area
            if viewModel.isLoading {
                ProgressView("Loading image...")
                    .frame(width: 300, height: 300)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
            } else if let imageURL = viewModel.imageURL {
                AsyncImage(url: URL(string: imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 300, height: 300)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                .shadow(radius: 5)
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 300, height: 300)
                    .overlay(
                        VStack {
                            Image(systemName: "photo")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                            Text("No image loaded")
                                .foregroundColor(.gray)
                        }
                    )
            }
            
            // Error message
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            // Buttons
            HStack(spacing: 20) {
                Button(action: {
                    viewModel.fetchRandomImage()
                }) {
                    Text("Fetch Random Image")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .disabled(viewModel.isLoading)
                
                Button(action: {
                    viewModel.clearImage()
                }) {
                    Text("Clear")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .disabled(viewModel.isLoading)
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            viewModel.setModelContext(modelContext)
        }
    }
}

#Preview {
    ImageFetcherView()
}
