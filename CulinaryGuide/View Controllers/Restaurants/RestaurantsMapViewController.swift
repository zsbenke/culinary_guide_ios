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
                        left: 32,
                        bottom: navigationController.toolbar.frame.height,
                        right: 32
                    )
                } else {
                    edgePadding = UIEdgeInsets(
                        top: 0,
                        left: 32,
                        bottom: 0,
                        right: 32
                    )
                }

                guard let restaurantsViewController = self.restaurantsViewController else { return }

                if self.restaurants.isEmpty || restaurantsViewController.queryTokens.isEmpty {
                    self.mapView.setRegion(Localization.currentCountry.defaultRegion, animated: false)
                } else {
                    self.mapView.setDefaultMapRect(byUnioningUserLocation: false, edgePadding: edgePadding, animated: true)
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

        registerForPreviewing(with: self, sourceView: annotationView)

        return annotationView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? RestaurantAnnotation else { return }

        let restaurant = annotation.restaurant
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "RestaurantDetailViewController") as! RestaurantDetailViewController
        controller.restaurantID = restaurant.id
        navigationController?.pushViewController(controller, animated: true)
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

extension RestaurantsMapViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let annotationView = previewingContext.sourceView as? RestaurantMarkerAnnotationView else { return nil }
        guard let annotation = annotationView.annotation as? RestaurantAnnotation else { return nil }

        let restaurant = annotation.restaurant

        if let popoverFrame = rectForAnnotationViewWithPopover(view: annotationView) {
            previewingContext.sourceRect = popoverFrame
        }
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let restaurantDetailViewController = storyboard.instantiateViewController(withIdentifier: "RestaurantDetailViewController") as! RestaurantDetailViewController
        restaurantDetailViewController.restaurantID = restaurant.id

        return restaurantDetailViewController
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
}

private extension RestaurantsMapViewController {
    func rectForAnnotationViewWithPopover(view: MKAnnotationView) -> CGRect? {
        var popover: UIView?

        for view in view.subviews {
            for view in view.subviews {
                for view in view.subviews {
                    popover = view
                }
            }
        }

        if let popover = popover, let frame = popover.superview?.convert(popover.frame, to: view) {
            return CGRect(
                x: frame.origin.x,
                y: frame.origin.y,
                width: frame.width,
                height: frame.height + view.frame.height
            )
        }

        return nil
    }
}
