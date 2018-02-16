import Foundation

struct API {
    static var environment: Environment = .production
    private static var domain: String {
        switch environment {
        case .development:
            return "http://culinary-guide-api.test"
        case .production:
            return "http://enfys.com"
        case .staging:
            return "http://enfys-staging.decoding.io"
        }
    }
    
    static let baseURL = "\(domain)/api/v1"
}
