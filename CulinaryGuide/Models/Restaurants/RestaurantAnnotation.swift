import MapKit

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

extension Restaurant {
    func toAnnotation() -> RestaurantAnnotation? {
        guard let title = title else { return nil }
        guard let address = address else { return nil }
        guard let coordinate = calculateCoordinate() else { return nil }
        return RestaurantAnnotation.init(title: title, locationName: title, discipline: address, coordinate: coordinate)
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
