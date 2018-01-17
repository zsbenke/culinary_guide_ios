import Foundation
import MapKit

protocol PointOfInterest {
  var id: Int? { get }
  var title: String? { get }
  var address: String? { get }
  var latitude: String? { get }
  var longitude: String? { get }
}
