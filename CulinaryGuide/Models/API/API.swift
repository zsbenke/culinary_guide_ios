import Foundation

enum Environment {
    case production
    case staging
    case development
}

struct API {
    static var environment: Environment = .staging
    private static var domain: String {
        switch environment {
        case .development:
            return "http://develop.decoding.io:3000"
        case .production:
            return "http://api.gaultmillau.eu"
        case .staging:
            return "http://culinary-guide-api-staging.decoding.io"
        }
    }
    
    static let baseURL = "\(domain)/api/v1"
}
