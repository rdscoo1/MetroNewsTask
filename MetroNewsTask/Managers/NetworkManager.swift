import Foundation

protocol INetworkManager {
    func makeRequest(request: IRequest, completion: @escaping(Result<[Tweet], RequestError>) -> Void)
}

class NetworkManager: INetworkManager {
    
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func makeRequest(request: IRequest,
                            completion: @escaping(Result<[Tweet], RequestError>) -> Void) {
        
        guard let urlRequest = request.urlRequest else {
            completion(.failure(.invalidUrl))
            return
        }
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                completion(.failure(.client))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.server))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            let models = TwitterParser.instance.parseTweets(data: data)
            if let tweets = models {
                completion(.success(tweets))
            } else {
                completion(.failure(.unableToDecode))
            }
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            task.resume()
        }
    }
}
