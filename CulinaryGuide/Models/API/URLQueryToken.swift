import Foundation

struct URLQueryToken {
    enum TokenType: String {
        case column
        case value
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
        return lhs.column == rhs.column && lhs.value == rhs.value
    }
}

extension Set where Iterator.Element == URLQueryToken {
    mutating func removeSearchTokens() {
        for token in searchTokens() {
            remove(token)
        }
    }
    
    func searchToken() -> URLQueryToken? {
        return searchTokens().first
    }

    func searchTokens() -> Set<URLQueryToken> {
        return filter { $0.column == "search" }
    }
}
