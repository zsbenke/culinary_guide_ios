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
            }
        }
    }
    var restaurantsViewController: RestaurantsViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        self.restaurantsViewController = parent as? RestaurantsViewController
    }
}
