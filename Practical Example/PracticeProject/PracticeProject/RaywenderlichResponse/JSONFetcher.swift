import Foundation

enum JSONFetchError: Error, Equatable {
    case invalidResponse
    case statusCode(Int)
}

class JSONFetcher<T: JSONRequestProtocol> {
    let request: T
    let urlSession: URLSession

    init(request: T, urlSession: URLSession = .shared) {
        self.request = request
        self.urlSession = urlSession
    }

    func fetch(completionHandler: @escaping (RaywenderlichResponse?, Error?) -> Void) {
        do {
            let urlRequest = try request.makeRequest()
            urlSession.dataTask(with: urlRequest) { data, response, error in
                guard let data = data else {
                    return completionHandler(nil, error)
                }
                do {
                    try self.validate(response)
                    let parsedResponse = try self.request.parseResponse(data: data)
                    completionHandler(parsedResponse, nil)
                } catch {
                    completionHandler(nil, error)
                }
            }.resume()
        } catch {
            return completionHandler(nil, error)
        }
    }

    private func validate(_ response: URLResponse?) throws {
        guard let response = response as? HTTPURLResponse else {
            throw JSONFetchError.invalidResponse
        }

        guard (200..<300).contains(response.statusCode) else {
            throw JSONFetchError.statusCode(response.statusCode)
        }
    }
}
