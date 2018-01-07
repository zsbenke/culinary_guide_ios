//
//  APIRequestOperation.swift
//  CulinaryGuide
//
//  Created by Benke Zsolt on 2018. 01. 07..
//  Copyright © 2018. Benke Zsolt. All rights reserved.
//

import Foundation

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

    private func request(_ apiRequest: URLRequest, completionHandler: @escaping (_ data: Data?) -> Void) {
        let authToken = "Token token=eyJhbGciOiJIUzI1NiJ9.eyJ1bmlxdWVfaGFzaCI6InRlc3QifQ.9RwhNNuROSt_DpadCdGhSICbp0HSceu6Nv1u3sn5q-E"
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.httpAdditionalHeaders = ["Authorization": authToken]
        let session = URLSession(configuration: sessionConfiguration)

        let dataTask = session.dataTask(with: apiRequest) { data, response, error in
            if (error != nil) {
                guard let error = error else { return }
                print(error.localizedDescription)
            } else {
                if let response = response as? HTTPURLResponse {
                    switch response.statusCode {
                    case 401:
                        print("Not authorized")
                    case 200:
                        print("Logged in")
                        completionHandler(data)
                    default:
                        print("unknown status code")
                    }
                }
            }
        }
        dataTask.resume()
    }
}
