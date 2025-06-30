//
//  File name: api_request_example_iosUITestsLaunchTests.swift
//  Project name: api-request-example-ios
//  Workspace name: Untitled 2
//
//  Created by: nothing-to-add on 01/07/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import XCTest

final class api_request_example_iosUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
