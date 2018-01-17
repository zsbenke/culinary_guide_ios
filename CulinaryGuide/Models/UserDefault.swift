import Foundation

enum UserDefaultKey: String, CustomStringConvertible {
    case country = "Country"
    
    var description: String {
        return rawValue
    }
}
