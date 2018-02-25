import Foundation

extension URL {
    func stringWithoutScheme() -> String {
        if let urlScheme = self.scheme {
            return self.absoluteString.replacingOccurrences(of: "\(urlScheme)://", with: "")
        }

        return self.absoluteString
    }
}
