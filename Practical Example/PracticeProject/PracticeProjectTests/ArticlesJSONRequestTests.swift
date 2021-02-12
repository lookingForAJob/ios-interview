@testable import PracticeProject
import XCTest

struct ArticlesJSONRequest {
    struct Constant {
        static let articlesURL = "https://github.com/raywenderlich/ios-interview/blob/master/Practical%20Example/articles.json"
    }

    func makeRequest() -> URLRequest {
        let components = URLComponents(string: Constant.articlesURL)!

        return URLRequest(url: components.url!)
    }
}

class ArticlesJSONRequestTests: XCTestCase {
    func test_requestIsValid() {
        let request = ArticlesJSONRequest().makeRequest()

        XCTAssertEqual(request.url?.absoluteString, "https://github.com/raywenderlich/ios-interview/blob/master/Practical%20Example/articles.json")
    }
}
