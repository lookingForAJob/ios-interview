import Foundation
@testable import PracticeProject
import XCTest

class RaywenderlichCourseJSONParser {
    func parseResponse(data: Data) throws -> [RaywenderlichCourse] {
        return try JSONDecoder().decode([RaywenderlichCourse].self, from: data)
    }
}

class RaywenderlichCourseJSONParserTests: XCTestCase {
    func test_parseResponse() throws {
        let jsonData = "[{\"data\":[{\"attributes\":{\"name\":\"dummy\"}}]}]".data(using: .utf8)!

        let response = try RaywenderlichCourseJSONParser().parseResponse(data: jsonData)

        let expectedAttributes = RaywenderlichCourse.Attributes(name: "dummy")
        let expectedData = [RaywenderlichCourse.Data(attributes: expectedAttributes)]
        let expectedRaywenderlichCourse = RaywenderlichCourse(data: expectedData)
        XCTAssertEqual(response, [expectedRaywenderlichCourse])
    }
}
