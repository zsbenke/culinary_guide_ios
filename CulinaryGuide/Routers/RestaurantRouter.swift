//
//  RestaurantRouter.swift
//  CulinaryGuide
//
//  Created by Benke Zsolt on 2018. 01. 07..
//  Copyright © 2018. Benke Zsolt. All rights reserved.
//

import Foundation

enum RestaurantRouter: Router, CustomStringConvertible {
    static let baseURLEndpoint: String = "\(API.baseURL)/restaurants"

    case index
    case search([URLQueryToken])
    case show(Int)

    var method: String {
        switch self {
        case .index, .search, .show:
            return "GET"
        }
    }

    func asURLRequest() -> URLRequest {
        let url: URL = {
            let path: String?
            switch self {
            case .index, .search:
                path = ""
            case .show(let id):
                path = "\(id)"
            }

            var tokens: [URLQueryItem] = []

            switch self {
            case .search(let assignedTokens):
                assignedTokens.forEach { token in
                    tokens.append(token.columnItem)
                    tokens.append(token.valueItem)
                }
            default:
                tokens = []
            }

            var url = URL(string: RestaurantRouter.baseURLEndpoint)!
            if let path = path { url.appendPathComponent(path) }
            var urlComponents = URLComponents.init(url: url, resolvingAgainstBaseURL: false)
            urlComponents?.queryItems = tokens
            print(urlComponents!.url!)
            return urlComponents!.url!
        }()

        var request = URLRequest(url: url)

        request.httpMethod = method
        return request
    }

    public var description: String {
        return String(describing: self.asURLRequest())
    }
}

