@testable import PracticeProject
import XCTest

class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("Request with no handler")
            return
        }

        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {
        // TODO: what do?
    }
}

class JSONFetcherTests: XCTestCase {
    private var fetcher: JSONFetcher<JSONRequest>!

    override func setUp() {
        super.setUp()

        let request = JSONRequest(url: URL(string: "https://dummyURL")!)

        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)

        fetcher = JSONFetcher(request: request, urlSession: urlSession)
    }

    func test_fetch() {
        let mockJSONData = "{\"data\":[{\"attributes\":{\"name\":\"dummy\"}}]}".data(using: .utf8)!
        MockURLProtocol.requestHandler = { _ in
            return (HTTPURLResponse(), mockJSONData)
        }

        let expectation = XCTestExpectation(description: "expected response")
        fetcher.fetch { data, error in
            XCTAssertNotNil(data?.data)
            XCTAssertEqual(data?.data[0].attributes.name, "dummy")
            XCTAssertNil(error)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func test_fetchMultiple() {
        let mockJSONString = """
            {\"data\":[
                {\"attributes\":{\"name\":\"dummy1\"}},
                {\"attributes\":{\"name\":\"dummy2\"}},
                {\"attributes\":{\"name\":\"dummy3\"}}
            ]}
        """
        let mockJSONData = mockJSONString.data(using: .utf8)!
        MockURLProtocol.requestHandler = { _ in
            return (HTTPURLResponse(), mockJSONData)
        }

        let expectation = XCTestExpectation(description: "expected response")
        fetcher.fetch { data, error in
            XCTAssertEqual(data?.data.count, 3)
            XCTAssertNil(error)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func test_fetchInvalidJSON() {
        let mockJSONData = "invalid json".data(using: .utf8)!
        MockURLProtocol.requestHandler = { _ in
            return (HTTPURLResponse(), mockJSONData)
        }

        let expectation = XCTestExpectation(description: "expected error")
        fetcher.fetch { data, error in
            XCTAssertNil(data)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }
}
