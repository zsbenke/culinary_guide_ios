import Foundation

struct API {
    static var environment: Environment = .development
    private static var domain: String {
        switch environment {
        case .development:
            return "http://culinary-guide-api.test/"
        case .production:
            return "http://api.gaultmillau.eu"
        case .staging:
            return "http://culinary-guide-api-staging.decoding.io"
        }
    }
    
    static let baseURL = "\(domain)/api/v1"
}
