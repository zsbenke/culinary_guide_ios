import Foundation

struct API {
    static var environment: Environment = .production
    static var domain: String {
        switch environment {
        case .development:
            return "http://culinary-guide-api.test"
        case .production:
            return "http://api.enfys.com"
        case .staging:
            return "http://enfys-staging.decoding.io"
        }
    }
    
    static let baseURL = "\(domain)/v1"
}
