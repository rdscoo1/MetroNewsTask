import Foundation

class TweetsRequest: IRequest {
        
    var urlRequest: URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = Constants.baseUrl
        urlComponents.path = "/api/tweets/v1.0/"

        guard let url = urlComponents.url else {
            return nil
        }
        
        var request = URLRequest(url: url, timeoutInterval: 10.0)

        request.httpMethod = HTTPMethod.get.rawValue
        return request
    }
    
}
