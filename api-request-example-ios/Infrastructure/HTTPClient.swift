//
//  File name: HTTPClient.swift
//  Project name: api-request-example-ios
//  Workspace name: api-request-example-ios
//
//  Created by: nothing-to-add on 30/06/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import Foundation

protocol HTTPClient {
    
    func get(from urlString: String) async -> Swift.Result<(Data, HTTPURLResponse), NetworkError>
}
