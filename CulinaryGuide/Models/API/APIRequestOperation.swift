import UIKit
import CloudKit
import JSONWebToken

class APIRequestOperation: AsyncOperation {
    let urlRequest: URLRequest
    var data: Data?

    private static let publicUniqueHash = "public"
    
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

    static func authenticate() {
        func store(uniqueHash: String) {
            UserDefaults.standard.set("\(uniqueHash)", forKey: "uniqueHash")
            let payload = APIRequestOperation.encodePayload(uniqueHash: uniqueHash)
            print("Session started: \(payload)")
        }

        let container = CKContainer.default()
        container.fetchUserRecordID { (record, error) in
            var uniqueHash = publicUniqueHash
            if error != nil {
                print(error!.localizedDescription)
            }

            if let record = record {
                uniqueHash = record.recordName
            }

            guard let previousUnqiueHash = UserDefaults.standard.string(forKey: "uniqueHash") else { return store(uniqueHash: uniqueHash) }
            guard previousUnqiueHash == uniqueHash else { return store(uniqueHash: uniqueHash) }
            let payload = APIRequestOperation.encodePayload(uniqueHash: uniqueHash)
            print("Resume session: \(payload)")
        }
    }
}

private extension APIRequestOperation {
    func request(_ apiRequest: URLRequest, completionHandler: @escaping (_ data: Data?) -> Void) {
        let uniqueHash = UserDefaults.standard.string(forKey: "uniqueHash") ?? APIRequestOperation.publicUniqueHash
        let payload = APIRequestOperation.encodePayload(uniqueHash: uniqueHash)
        let authToken = "Token token=\(payload)"
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.httpAdditionalHeaders = ["Authorization": authToken]
        let session = URLSession(configuration: sessionConfiguration)

        print("Active session: \(payload)")

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

    static func encodePayload(uniqueHash: String) -> String {
        return JSONWebToken.encode(["unique_hash": uniqueHash], algorithm: .hs256(APIKey.secret))
    }
}
