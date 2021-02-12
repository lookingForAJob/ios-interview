@testable import PracticeProject
import XCTest

struct VideosJSONRequest {
    struct Constant {
        static let videosURL = "https://github.com/raywenderlich/ios-interview/blob/master/Practical%20Example/videos.json"
    }

    func makeRequest() -> URLRequest {
        let components = URLComponents(string: Constant.videosURL)!

        return URLRequest(url: components.url!)
    }
}

class VideosJSONRequestTests: XCTestCase {
    func test_requestIsValid() {
        let request = VideosJSONRequest().makeRequest()

        XCTAssertEqual(request.url?.absoluteString, "https://github.com/raywenderlich/ios-interview/blob/master/Practical%20Example/videos.json")
    }
}
