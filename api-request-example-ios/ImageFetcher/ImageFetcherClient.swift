//
//  File name: ImageFetcherClient.swift
//  Project name: api-request-example-ios
//  Workspace name: api-request-example-ios
//
//  Created by: nothing-to-add on 30/06/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import Foundation

protocol ImageFetcherClientProtocol {
    func fetchImage() async throws -> ImageFetcherResponse
}

struct ImageFetcherClient: ImageFetcherClientProtocol {
    private let baseURL = "https://dog.ceo/api/breeds/image/random"
    private let httpClient: HTTPClient
    
    init(networkClient: HTTPClient = HTTPClientManager.shared.getHTTPClient()) {
        httpClient = networkClient
    }
    
    func fetchImage() async throws -> ImageFetcherResponse {
        let networkManager = NetworkManager(httpClient: httpClient)
        
        let data = try await networkManager.fetchData(from: baseURL, as: ImageFetcherResponse.self)
        return data
    }
}
