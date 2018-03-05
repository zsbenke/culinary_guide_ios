import MapKit

class RestaurantAnnotation: NSObject, MKAnnotation {
    let title: String?
    let address: String
    let coordinate: CLLocationCoordinate2D
    let restaurant: Restaurant

    init(title: String, address: String, coordinate: CLLocationCoordinate2D, restaurant: Restaurant) {
        self.title = title
        self.coordinate = coordinate
        self.address = address
        self.restaurant = restaurant

        super.init()
    }

    var subtitle: String? {
        return address
    }
}

extension Restaurant {
    func toAnnotation() -> RestaurantAnnotation? {
        guard let title = title else { return nil }
        guard let address = address else { return nil }
        guard let coordinate = calculateCoordinate() else { return nil }
        return RestaurantAnnotation.init(title: title, address: address, coordinate: coordinate, restaurant: self)
    }

    func calculateCoordinate() -> CLLocationCoordinate2D? {
        guard let latitude = latitude else { return nil }
        guard let longitude = longitude else { return nil }

        let locationLatitude = Double(latitude)
        let locationLongitude = Double(longitude)

        guard let lat = locationLatitude, let long = locationLongitude else { return nil }

        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
}
