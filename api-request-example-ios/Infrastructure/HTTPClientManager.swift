//
//  File name: HTTPClientManager.swift
//  Project name: api-request-example-ios
//  Workspace name: api-request-example-ios
//
//  Created by: nothing-to-add on 30/06/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import Foundation

struct HTTPClientManager {
    static let shared = HTTPClientManager()
    
    private init() {}
    
    func getHTTPClient() -> HTTPClient {
        RemoteHTTPClient()
        // add mock option
    }
}
