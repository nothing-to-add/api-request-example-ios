//
//  File name: ContentView.swift
//  Project name: api-request-example-ios
//  Workspace name: Untitled 1
//
//  Created by: nothing-to-add on 30/06/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import SwiftUI

struct ContentView: View {
    @StateObject private var coordinator = NavigationCoordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            VStack(spacing: 30) {
                Text("API Request App")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)
                
                Spacer()
                
                VStack(spacing: 20) {
                    Button {
                        coordinator.navigate(to: .defaultView)
                    } label: {
                        HStack {
                            Image(systemName: "list.bullet")
                                .font(.title2)
                            Text("Default View")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                    }
                    
                    Button {
                        coordinator.navigate(to: .imageFetcher)
                    } label: {
                        HStack {
                            Image(systemName: "photo")
                                .font(.title2)
                            Text("Image Fetcher")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(12)
                    }
                    
                    Button {
                        coordinator.navigate(to: .apiRequestHistory)
                    } label: {
                        HStack {
                            Image(systemName: "clock.arrow.circlepath")
                                .font(.title2)
                            Text("API Request History")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(12)
                    }
                    
                    Button {
                        coordinator.navigate(to: .uikitExample)
                    } label: {
                        HStack {
                            Image(systemName: "iphone")
                                .font(.title2)
                            Text("UIKit Example")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 40)
                
                Spacer()
            }
            .navigationTitle("Main Menu")
            .navigationDestination(for: NavigationDestination.self) { destination in
                coordinator.view(for: destination)
            }
        }
        .environmentObject(coordinator)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Item.self, ImageModel.self], inMemory: true)
}
