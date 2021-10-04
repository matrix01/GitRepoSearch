import Foundation
import UIKit

enum GitAPIs {
    case search(searchText: String)
}

extension GitAPIs: EndPointType {
    var baseURL: URL? {
        var urlComponents = URLComponents()
        urlComponents.host = host
        urlComponents.scheme = scheme
        urlComponents.path = path
        urlComponents.queryItems = params
        return urlComponents.url
    }
    
    private var host: String {
        "api.github.com"
    }
    
    private var scheme: String {
        "https"
    }

    var path: String {
        switch self {
        case .search:
            return "/search/repositories"
        }
    }
    
    var params: [URLQueryItem]? {
        switch self {
        case .search(let searchText):
            return [URLQueryItem(name: "q", value: searchText)]
        }
    }
    
    private var method: String {
        switch self {
        case .search:
            return "GET"
        }
    }
    
    var userAgent: String {
        let projectName     = "GithubRepoSearch"
        let model           = UIDevice.current.model
        let systemVersion   = UIDevice.current.systemVersion
        let name            = UIDevice.current.name
        let scale           = UIScreen.main.scale

        return "\(projectName) (\(model); iOS \(systemVersion); DeviceName/\(name); Scale/\(scale)"
    }

    var request: URLRequest? {
        guard let url = baseURL else { return nil }
        var request = URLRequest(url: url)

        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(userAgent, forHTTPHeaderField: "User-Agent")
        request.timeoutInterval = 20000.0
        return request
    }
}
