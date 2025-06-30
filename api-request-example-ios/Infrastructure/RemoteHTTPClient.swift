//
//  File name: RemoteHTTPClient.swift
//  Project name: api-request-example-ios
//  Workspace name: api-request-example-ios
//
//  Created by: nothing-to-add on 30/06/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import Foundation

final class RemoteHTTPClient: HTTPClient {
    func get(from urlString: String) async -> Swift.Result<(Data, HTTPURLResponse), NetworkError> {
        
        guard let url = URL(string: urlString) else {
            return .failure(.invalidURL)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.noData)
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                return .failure(.serverError("Error with status code: \(httpResponse.statusCode)"))
            }
            
            return .success((data, httpResponse))
        } catch {
            return .failure(.noData)
        }
    }
    
}
