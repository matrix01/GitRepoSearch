import Foundation


typealias ResultHandler<T, E> = (Swift.Result<T, Error>) -> Void

// protocol
protocol NetworkingProtocol {

    func requestNetworkTask<T: Codable>(endpoint: GitAPIs,
                                        type: T.Type,
                                        completion: @escaping ResultHandler<T, Error>)

}

class Networking: NetworkingProtocol {
    
    func requestNetworkTask<T: Codable>(endpoint: GitAPIs,
                                        type: T.Type,
                                        completion:  @escaping ResultHandler<T, Error>) {
        guard let request = endpoint.request else {
            return completion(.failure(GitRepoError.internalError))
        }
        
        let urlSession = URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            if let serverError = error,
               serverError.localizedDescription != "cancelled" {
                completion(.failure(serverError))
            }
            guard let data = data else {
                return
            }
            let response = Response(data: data)
            guard let decoded = response.decode(type) else {
                return completion(.failure(GitRepoError.emptyData))
            }
            completion(.success(decoded))
        }
        urlSession.resume()
    }
}
