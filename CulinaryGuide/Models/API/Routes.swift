import Foundation

protocol Router {
    static var baseURLEndpoint: String { get }
    func asURLRequest() -> URLRequest
}

enum RestaurantRouter: Router, CustomStringConvertible {
    static let baseURLEndpoint: String = "\(API.baseURL)/restaurants"
    
    case index
    case search([URLQueryToken])
    case show(Int)
    
    var method: String {
        switch self {
        case .index, .search, .show:
            return "GET"
        }
    }
    
    func asURLRequest() -> URLRequest {
        let url: URL = {
            let path: String?
            switch self {
            case .index, .search:
                path = ""
            case .show(let id):
                path = "\(id)"
            }
            
            let localeTokens = [
                URLQueryItem.init(name: "country", value: "\(Localization.currentCountry)"),
                URLQueryItem.init(name: "locale", value: "\(Localization.currentLocale)")
            ]
            var tokens = [URLQueryItem]()
            
            switch self {
            case .search(let assignedTokens):
                assignedTokens.forEach { token in
                    tokens.append(token.columnItem)
                    tokens.append(token.valueItem)
                }
                tokens += localeTokens
            default:
                tokens = localeTokens
            }
            
            var url = URL(string: RestaurantRouter.baseURLEndpoint)!
            if let path = path {
                url.appendPathComponent(path)
            }
            var urlComponents = URLComponents.init(url: url, resolvingAgainstBaseURL: false)
            urlComponents?.queryItems = tokens
            return urlComponents!.url!
        }()
        
        print(url)
        
        var request = URLRequest(url: url)
        
        request.httpMethod = method
        return request
    }
    
    public var description: String {
        return String(describing: self.asURLRequest())
    }
}

