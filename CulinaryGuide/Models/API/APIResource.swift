import Foundation

protocol APIResource {
    associatedtype Router
    associatedtype Record
    
    static var router: Router { get }
    
    static func index(completionHandler: @escaping (_ records: [Record?]) -> Void)
    static func index(search tokens: [URLQueryToken], completionHandler: @escaping  (_ records: [Record?]) -> Void)
    static func show(_ id: Int, completionHandler: @escaping  (_ record: Record?) -> Void)
}
