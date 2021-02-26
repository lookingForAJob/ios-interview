import Foundation

protocol JSONRequestProtocol {
    func makeRequest() throws -> URLRequest
    func parseResponse(data: Data) throws -> RaywenderlichResponse
}

struct JSONRequest: JSONRequestProtocol {
    let url: URL

    func makeRequest() throws -> URLRequest {
        return URLRequest(url: url)
    }

    func parseResponse(data: Data) throws -> RaywenderlichResponse {
        return try JSONDecoder().decode(RaywenderlichResponse.self, from: data)
    }
}
