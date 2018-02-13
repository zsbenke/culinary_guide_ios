import UIKit

class APIRequestOperation: AsyncOperation {
    let urlRequest: URLRequest
    var data: Data?
    
    init(urlRequest: URLRequest) {
        self.urlRequest = urlRequest
        super.init()
    }
    
    override func main() {
        request(urlRequest) { (data) in
            self.data = data
            self.state = .Finished
        }
    }
}

private extension APIRequestOperation {
    func request(_ apiRequest: URLRequest, completionHandler: @escaping (_ data: Data?) -> Void) {
        // TODO: visszakapcsolni a felhasználói azonosítást
        // Ez az auth token egy ideiglenes használt felhasználó JWT tokenje.
        // let authToken = "Token token=eyJhbGciOiJIUzI1NiJ9.eyJ1bmlxdWVfaGFzaCI6InRlc3QifQ.9RwhNNuROSt_DpadCdGhSICbp0HSceu6Nv1u3sn5q-E"
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        // sessionConfiguration.httpAdditionalHeaders = ["Authorization": authToken]
        let session = URLSession(configuration: sessionConfiguration)

        let dataTask = session.dataTask(with: apiRequest) { data, response, error in
            if (error != nil) {
                guard let error = error else { return }
                DispatchQueue.main.async {
                    self.showAlert(message: error.localizedDescription)
                }
            } else {
                if let response = response as? HTTPURLResponse {
                    switch response.statusCode {
                    case 401:
                        DispatchQueue.main.async {
                            let notAuthorizedMessage = NSLocalizedString("Not authorized", comment: "A hálózati hibát jelző alert szövege, amikor a felhasználó azonosítása sikertelen.")
                            self.showAlert(message: notAuthorizedMessage)
                        }
                    case 200:
                        completionHandler(data)
                    default:
                        DispatchQueue.main.async {
                            let unknownStatusCodeMessage = NSLocalizedString("Unknown status code", comment: "A hálózati hibát jelző alert szövege, amikor ismeretlen HTTP státusz kóddal tér vissza az API (ajánlott fordítás: Ismeretlen HTTP státusz kód).")
                            self.showAlert(message: unknownStatusCodeMessage)
                        }
                    }
                }
            }
        }
        dataTask.resume()
    }

    func showAlert(message: String) {
        let alertControllerTitle = NSLocalizedString("Network Error", comment: "A hálózati hibát jelző alert címsorának szövege.")
        let cancelActionTitle = NSLocalizedString("OK", comment: "A hálózati hibát jelző alert OK gombjának szövege.")
        let alertController = UIAlertController.init(title: alertControllerTitle, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: cancelActionTitle, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        let viewController = UIApplication.shared.delegate?.window!?.rootViewController
        viewController?.present(alertController, animated: true, completion: nil)
    }
}
