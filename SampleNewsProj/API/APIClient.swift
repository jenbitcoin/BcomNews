import Foundation

public struct DataResponse {
    public let data: Data?
    public let urlResponse: URLResponse?
    public let error: Error?
    
    init(data: Data?, urlResponse: URLResponse?, error: Error?) {
        self.data = data
        self.urlResponse = urlResponse
        self.error = error
    }
}
/**
 API client class
 */
public class APIClient {
    private static let basePath = "wp-json/bcn/v1/"
    
    public func request<T>(url: URL,
                           completion: @escaping (APIResponse<T>) -> Void,
                           parse: @escaping (Data) -> APIResponse<T>) {
        let request = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, urlResponse, error in
            let dataResponse = DataResponse(data: data, urlResponse: urlResponse, error: error)
            APIClient.handleResponse(response: dataResponse, completion, parse: parse)
        }
        
        task.resume()
    }

    // MARK: - Private
    
    /**
     Parse response.
     - Parameter response: received response
     - Parameter completionHandler: completion handler to invoke with persed data
     - Parameter parse: closure to parse successfull response body
     */
    static func handleResponse<T>(response: DataResponse,
                                  _ completionHandler: (APIResponse<T>) -> Void,
                                  parse: (Data) -> APIResponse<T>) {
        let result: APIResponse<T>
        
        guard response.error == nil else {
            result = .failure(.ServerError)
            return
        }
        
        guard let data = response.data else {
            result = .failure(.UnexpectedResponse)
            return
        }
        
        result = parse(data)
        
        completionHandler(result)
    }
    
    /**
     Formats given api call path and creates full URL
     - Parameter format: format string
     - Parameter arguments: format arguments
     */
    static func apiUrlFromPath(format: String, _ queryItems: [URLQueryItem]) -> URL {
        let c = NSURLComponents()
        c.scheme = SDKConfiguration.shared.api.apiRootScheme
        c.host = SDKConfiguration.shared.api.apiRootHost
        let formattedPath = String(format: format)
        c.path = "/\(APIClient.basePath)\(formattedPath)"
        c.queryItems = queryItems
        return c.url!
    }
}
