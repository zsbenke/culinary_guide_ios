import UIKit

class RestaurantDetailViewController: UITableViewController {
    var restaurantID: Int? {
        didSet {
            configureView()
        }
    }
    var restaurant: Restaurant?
    
    @IBOutlet weak var restaurantTitleLabel: UILabel!
    @IBOutlet weak var addressCell: UITableViewCell!
    @IBOutlet weak var phoneCell: UITableViewCell!
    @IBOutlet weak var openTimesCell: UITableViewCell!
    @IBOutlet weak var defPeopleOneCell: UITableViewCell!
    @IBOutlet weak var defPeopleTwoCell: UITableViewCell!
    @IBOutlet weak var defPeopleThreeCell: UITableViewCell!
    @IBOutlet weak var websiteCell: UITableViewCell!
    @IBOutlet weak var emailCell: UITableViewCell!
    @IBOutlet weak var facebookCell: UITableViewCell!
    @IBOutlet weak var reservationsCell: UITableViewCell!
    @IBOutlet weak var parkingCell: UITableViewCell!
    @IBOutlet weak var menuPriceCell: UITableViewCell!
    @IBOutlet weak var creditCardCell: UITableViewCell!
    @IBOutlet weak var wifiCell: UITableViewCell!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.largeTitleDisplayMode = .never
        
        if restaurant != nil {
            configureView()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureView() {
        guard let restaurantID = restaurantID else { return }
        Restaurant.show(restaurantID) { restaurant in
            self.restaurant = restaurant
            
            DispatchQueue.main.async {
                guard let restaurant = self.restaurant else { return }
                self.restaurantTitleLabel.text = restaurant.title
                self.addressCell.textLabel?.text = restaurant.address
            }
        }
    }
}

extension RestaurantDetailViewController {
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let tableSectionFooterView = UIView()
        let tableViewSectionSeparator = CALayer()
        let numberOfSection = section + 1

        tableViewSectionSeparator.frame = CGRect(x: 16.0, y: 0, width: UIScreen.main.bounds.width, height: 0.5)
        tableViewSectionSeparator.backgroundColor = UIColor.BrandColor.detailSeparator.cgColor

        if numberOfSection != super.numberOfSections(in: tableView) {
            tableSectionFooterView.layer.addSublayer(tableViewSectionSeparator)
        }

        return tableSectionFooterView
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
}
