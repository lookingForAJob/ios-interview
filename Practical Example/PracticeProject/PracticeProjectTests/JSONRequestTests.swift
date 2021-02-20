@testable import PracticeProject
import XCTest

class JSONRequestTests: XCTestCase {
    func test_makeRequest() throws {
        let components = URLComponents(string: "https://dummyURL")
        let urlRequest = try JSONRequest(url: components!.url!).makeRequest()

        XCTAssertEqual(urlRequest.url?.absoluteString, "https://dummyURL")
    }

    func test_parseResponse() throws {
        let jsonData = "[{\"data\":[{\"attributes\":{\"name\":\"dummy\"}}]}]".data(using: .utf8)!

        let response = try JSONRequest(url: URL(string: "https://dummyURL")!).parseResponse(data: jsonData)

        let expectedAttributes = RaywenderlichCourse.Attributes(name: "dummy")
        let expectedData = [RaywenderlichCourse.Data(attributes: expectedAttributes)]
        let expectedRaywenderlichCourse = RaywenderlichCourse(data: expectedData)
        XCTAssertEqual(response, [expectedRaywenderlichCourse])
    }
}
