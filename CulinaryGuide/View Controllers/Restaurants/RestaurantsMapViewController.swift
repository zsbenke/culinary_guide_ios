import UIKit
import MapKit

class RestaurantsMapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!

    var restaurants = [Restaurant?]() {
        didSet {
            DispatchQueue.main.async {
                self.mapView.removeAnnotations(self.mapView.annotations)

                for restaurant in self.restaurants {
                    guard let restaurant = restaurant else { continue }
                    guard let annotation = restaurant.toAnnotation() else { continue }
                    self.mapView.addAnnotation(annotation)
                }

                var edgePadding: UIEdgeInsets

                if let navigationController = self.navigationController {
                    edgePadding = UIEdgeInsets(
                        top: navigationController.navigationBar.frame.height,
                        left: 0,
                        bottom: navigationController.toolbar.frame.height,
                        right: 0
                    )
                } else {
                    edgePadding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                }

                self.mapView.setDefaultMapRect(byUnioningUserLocation: false, edgePadding: edgePadding, animated: false)

                guard let restaurantsViewController = self.restaurantsViewController else { return }

                if self.restaurants.isEmpty || restaurantsViewController.queryTokens.isEmpty {
                    self.mapView.setRegion(Localization.currentCountry.defaultRegion, animated: false)
                } 
            }
        }
    }
    var restaurantsViewController: RestaurantsViewController? = nil

    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocalizationAuthorizationStatus()

        mapView.delegate = self
        mapView.isRotateEnabled = false
        mapView.register(RestaurantMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(RestaurantClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        self.restaurantsViewController = parent as? RestaurantsViewController
    }
}

extension RestaurantsMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? RestaurantAnnotation else { return nil }

        let identifier = "restaurantMarker"
        var annotationView: RestaurantMarkerAnnotationView

        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? RestaurantMarkerAnnotationView {
            dequeuedAnnotationView.annotation = annotation
            annotationView = dequeuedAnnotationView
        } else {
            annotationView = RestaurantMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }

        return annotationView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("tapped")
        guard let annotation = view.annotation as? RestaurantAnnotation else { return }

        let restaurant = annotation.restaurant
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "RestaurantDetailViewController") as! RestaurantDetailViewController
        controller.restaurantID = restaurant.id
        navigationController?.pushViewController(controller, animated: true)
    }

    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        print("center: \(mapView.region.center)")
        print("span: \(mapView.region.span)")
    }
}

private extension RestaurantsMapViewController {
    func checkLocalizationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}
