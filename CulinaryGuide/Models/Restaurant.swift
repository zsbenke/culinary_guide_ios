//
//  Restaurant.swift
//  CulinaryGuide
//
//  Created by Benke Zsolt on 2018. 01. 07..
//  Copyright © 2018. Benke Zsolt. All rights reserved.
//

import Foundation
import MapKit

struct Restaurant: PointOfInterest, Codable {
    let id: Int?
    let title: String?
    let address: String?
    let latitude: String?
    let longitude: String?
    let rating: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case address = "full_address"
        case latitude
        case longitude
        case rating
    }

    func toAnnotation() -> MKPointAnnotation? {
        guard let latitude = latitude else { return nil }
        guard let longitude = longitude else { return nil }

        let locationLatitude = Double(latitude)
        let locationLongitude = Double(longitude)

        guard let lat = locationLatitude, let long = locationLongitude else { return nil }

        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        return annotation
    }
}

extension Restaurant: APIResource {
    internal static let router = RestaurantRouter.self

    static func index(completionHandler: @escaping (_ restaurants: [Restaurant?]) -> Void) {
        let operationQueue = OperationQueue()
        let requestOperation = APIRequestOperation(urlRequest: router.index.asURLRequest())
        requestOperation.completionBlock = {
            guard let data = requestOperation.data else { return }
            do {
                let restaurants = try JSONDecoder().decode([Restaurant].self, from: data)
                completionHandler(restaurants)
            } catch {
                return
            }
        }
        operationQueue.addOperation(requestOperation)
    }

    static func index(search tokens: [URLQueryToken], completionHandler: @escaping (_ restaurants: [Restaurant?]) -> Void) {
        let operationQueue = OperationQueue()
        let requestOperation = APIRequestOperation(urlRequest: router.search(tokens).asURLRequest())
        requestOperation.completionBlock = {
            guard let data = requestOperation.data else { return }
            do {
                let restaurants = try JSONDecoder().decode([Restaurant].self, from: data)
                completionHandler(restaurants)
            } catch {
                return
            }
        }
        operationQueue.addOperation(requestOperation)
    }

    static func show(_ id: Int, completionHandler: @escaping (_ restaurant: Restaurant?) -> Void) {
        let operationQueue = OperationQueue()
        let requestOperation = APIRequestOperation(urlRequest: router.show(id).asURLRequest())
        requestOperation.completionBlock = {
            guard let data = requestOperation.data else { return }
            do {
                let restaurant = try JSONDecoder().decode(Restaurant.self, from: data)
                completionHandler(restaurant)
            } catch {
                return
            }

        }
        operationQueue.addOperation(requestOperation)
    }
}
