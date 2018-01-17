import Foundation

struct URLQueryToken {
    enum TokenType: CustomStringConvertible {
        case column, value
        
        public var description: String {
            var tokenTypeDescription: String
            
            switch self {
            case .column: tokenTypeDescription = "column"
            case .value: tokenTypeDescription = "value"
            }
            return tokenTypeDescription
        }
    }
    
    let column: String
    let value: String
    
    var columnItem: URLQueryItem {
        return URLQueryToken.initURLQueryItem(for: .column, value: column)
    }
    
    var valueItem: URLQueryItem {
        return URLQueryToken.initURLQueryItem(for: .value, value: value)
    }
    
    private static func initURLQueryItem(for tokenType: TokenType, value: String) -> URLQueryItem {
        return URLQueryItem(name: "tokens[][\(tokenType)]", value: value)
    }
}

extension URLQueryToken: CustomStringConvertible {
    public var description: String {
        return ["\(columnItem)", "\(valueItem)"].joined(separator: "&")
    }
}

extension URLQueryToken: Hashable {
    var hashValue: Int {
        return self.column.hashValue
    }
    
    static func ==(lhs: URLQueryToken, rhs: URLQueryToken) -> Bool {
        return lhs.column == rhs.column
    }
}

extension Set where Iterator.Element == URLQueryToken {
    mutating func removeSearchTokens() {
        remove(URLQueryToken.init(column: "search", value: ""))
    }
    
    func searchToken() -> URLQueryToken? {
        return filter { $0.column == "search" }.first
    }
}
