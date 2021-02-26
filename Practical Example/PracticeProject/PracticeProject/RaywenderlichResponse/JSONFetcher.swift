import Foundation

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
            print(urlRequest)
            urlSession.dataTask(with: urlRequest) { data, _, error in
                guard let data = data else {
                    return completionHandler(nil, error)
                }
                do {
                    print(data)
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
}
