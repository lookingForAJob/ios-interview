import Foundation

protocol JSONRequestProtocol {
    func makeRequest() throws -> URLRequest
    func parseResponse(data: Data) throws -> [RaywenderlichCourse]
}

struct JSONRequest: JSONRequestProtocol {
    let url: URL

    func makeRequest() throws -> URLRequest {
        return URLRequest(url: url)
    }

    func parseResponse(data: Data) throws -> [RaywenderlichCourse] {
        return try JSONDecoder().decode([RaywenderlichCourse].self, from: data)
    }
}
