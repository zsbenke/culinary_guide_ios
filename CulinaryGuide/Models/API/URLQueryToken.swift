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

private extension URLQueryToken {
    static func initURLQueryItem(for tokenType: TokenType, value: String) -> URLQueryItem {
        return URLQueryItem(name: "tokens[][\(tokenType)]", value: value)
    }
}

extension Set where Iterator.Element == URLQueryToken {
    func filter(column: String) -> Set<URLQueryToken> {
        return filter { $0.column == column }
    }

    func filter(column: String, value: String) -> Set<URLQueryToken> {
        return filter { $0.column == column && $0.value == value }
    }

    func searchTokens() -> Set<URLQueryToken> {
        return filter(column: "search")
    }

    func searchToken() -> URLQueryToken? {
        return searchTokens().first
    }

    mutating func removeSearchTokens() {
        for token in searchTokens() {
            remove(token)
        }
    }

    mutating func insert(column: String, value: String) {
        insert(URLQueryToken.init(column: column, value: value))
    }

    mutating func removeAll(column: String) {
        for token in filter(column: column) {
            remove(token)
        }
    }

    mutating func remove(column: String, value: String) {
        for token in filter(column: column, value: value) {
            remove(token)
        }
    }
}
