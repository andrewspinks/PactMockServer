//
//  PactMockServerTests.swift
//  PactMockServerTests
//
//  Created by Andrew Spinks on 10/06/2016.
//  Copyright © 2016 Pact. All rights reserved.
//

import XCTest
@testable import PactMockServer

class PactMockServerTests: XCTestCase {

  let pact = "{\n" +
  "\"provider\": {\n" +
  "  \"name\": \"Alice Service\"\n" +
  "},\n" +
  "\"consumer\": {\n" +
  "  \"name\": \"Consumer\"\n" +
  "},\n" +
  "\"interactions\": [\n" +
  "  {\n" +
  "    \"description\": \"a retrieve Mallory request\",\n" +
  "    \"request\": {\n" +
  "      \"method\": \"GET\",\n" +
  "      \"path\": \"/mallory\",\n" +
  "      \"query\": \"name=ron&status=good\"\n" +
  "    },\n" +
  "    \"response\": {\n" +
  "      \"status\": 200,\n" +
  "      \"headers\": {\n" +
  "        \"Content-Type\": \"text/html\"\n" +
  "      },\n" +
  "      \"body\": \"\\\"That is some good Mallory.\\\"\"\n" +
  "    }\n" +
  "  }\n" +
  "],\n" +
  "\"metadata\": {\n" +
  "  \"pact-specification\": {\n" +
  "    \"version\": \"1.0.0\"\n" +
  "  },\n" +
  "  \"pact-jvm\": {\n" +
  "    \"version\": \"1.0.0\"\n" +
  "  }\n" +
  "}\n" +
  "}\n"


  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  func testMatchingExample() {
    let port = PactMockServer.create_mock_server(pact, 1234)
    print("starting test on port \(port)")
  
    let url = NSURL(string: "http://localhost:\(port)/mallory?name=ron&status=good")
    let expectation = expectationWithDescription("Swift Expectations")

    let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
      print(NSString(data: data!, encoding: NSUTF8StringEncoding))
      
      XCTAssertTrue(PactMockServer.mock_server_matched(port))
      
      PactMockServer.cleanup_mock_server(port)
      expectation.fulfill()
    }

    task.resume()
    waitForExpectationsWithTimeout(5.0, handler:nil)
  }

  func testMismatchExample() {
    let port = PactMockServer.create_mock_server(pact, 1235)
    print("starting test on port \(port)")
    let url = NSURL(string: "http://localhost:\(port)/mallory?name=ron&status=NoGood")
    let expectation = expectationWithDescription("Swift Expectations")

    let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
      print(NSString(data: data!, encoding: NSUTF8StringEncoding))
      
      XCTAssertFalse(PactMockServer.mock_server_matched(port))
      let mismatchJson = String.fromCString(PactMockServer.mock_server_mismatches(port))
      print("-----------Mismatches!--------")
      print(mismatchJson)
      print("------------------------------")
      
      PactMockServer.cleanup_mock_server(port)
      expectation.fulfill()
    }

    task.resume()
    waitForExpectationsWithTimeout(5.0, handler:nil)
  }

}
