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
        case rating = "final_rating"
    }

    func toAnnotation() -> RestaurantAnnotation? {
        guard let title = title else { return nil }
        guard let address = address else { return nil }
        guard let coordinate = calculateCoordinate() else { return nil }
        return RestaurantAnnotation.init(title: title, locationName: title, discipline: address, coordinate: coordinate)
    }

    private func calculateCoordinate() -> CLLocationCoordinate2D? {
        guard let latitude = latitude else { return nil }
        guard let longitude = longitude else { return nil }

        let locationLatitude = Double(latitude)
        let locationLongitude = Double(longitude)

        guard let lat = locationLatitude, let long = locationLongitude else { return nil }

        return CLLocationCoordinate2D(latitude: lat, longitude: long)
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

class RestaurantAnnotation: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D

    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate

        super.init()
    }

    var subtitle: String? {
        return locationName
    }
}
