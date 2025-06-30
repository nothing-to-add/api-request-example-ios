//
//  File name: ImageModel.swift
//  Project name: api-request-example-ios
//  Workspace name: api-request-example-ios
//
//  Created by: nothing-to-add on 30/06/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import Foundation
import SwiftData

@Model
final class ImageModel {
    var timestamp: Date
    var imageURL: String?
    var isSuccess: Bool
    var errorMessage: String?
    
    init(timestamp: Date, imageURL: String? = nil, isSuccess: Bool, errorMessage: String? = nil) {
        self.timestamp = timestamp
        self.imageURL = imageURL
        self.isSuccess = isSuccess
        self.errorMessage = errorMessage
    }
}
