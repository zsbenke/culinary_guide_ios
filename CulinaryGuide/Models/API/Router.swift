import Foundation

protocol Router {
    static var baseURLEndpoint: String { get }
    func asURLRequest() -> URLRequest
}
