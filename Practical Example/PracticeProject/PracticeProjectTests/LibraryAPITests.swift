import Combine
@testable import PracticeProject
import XCTest

enum LibraryAPIError: Error, Equatable {
    case invalidResponse
    case statusCode(Int)
}

class LibraryAPI {
    let url: URL
    let urlSession: URLSession
    private var cancellable: AnyCancellable?

    init(url: URL, urlSession: URLSession = .shared) {
        self.url = url
        self.urlSession = urlSession
    }

    func getLibrary(completion: @escaping (RaywenderlichResponse) -> Void) {
        let justResponse = RaywenderlichResponse(data: [RaywenderlichResponse.Data(attributes: RaywenderlichResponse.Attributes(name: "just"))])
        cancellable = urlSession.dataTaskPublisher(for: url)
            .tryMap { $0.data }
            .decode(type: RaywenderlichResponse.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .catch { _ in Just(justResponse) }
            .sink { response in
                completion(response)
            }
    }
}

class LibraryAPITests: XCTestCase {
    private var url: URL!
    private var urlSession: URLSession!

    override func setUpWithError() throws {
        try super.setUpWithError()

        url = URL(string: "https://dummyURL")!
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: configuration)
    }

    func test_getLibrary() {
        let mockJSONData = "{\"data\":[{\"attributes\":{\"name\":\"dummy\"}}]}".data(using: .utf8)!
        MockURLProtocol.requestHandler = { _ in
            return (HTTPURLResponse(), mockJSONData)
        }
        let expectation = XCTestExpectation(description: "expected response")
        let libraryAPI = LibraryAPI(url: url, urlSession: urlSession)

        libraryAPI.getLibrary { response in
            XCTAssertEqual(response.data[0].attributes.name, "dummy")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func test_getLibrary_multiple() {
    }

    func test_getLibrary_invalidResponse() {
    }

    func test_getLibrary_invalidJSON() {
    }

    func test_getLibrary_statusCodeError() {
    }
}
