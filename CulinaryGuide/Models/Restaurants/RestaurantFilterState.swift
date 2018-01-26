import Foundation

struct RestaurantFilterState {
    typealias URLQueryTokens = Set<URLQueryToken>

    enum Column {
        static let region = "region"
        static let openAt = "open_at"
        static let wifi = "wifi"
        static let creditCard = "credit_card"
        static let search = "search"
        static let rating = "rating"
    }

    var queryTokens: URLQueryTokens

    var regions: Set<String> {
        get {
            var filteredRegions = Set<String>()
            for regionToken in queryTokens.filter(column: Column.region) {
                filteredRegions.insert(regionToken.value)
            }
            return filteredRegions
        }

        set(newValue) {
            queryTokens.removeAll(column: Column.region)
            for region in newValue { queryTokens.insert(column: Column.region, value: region) }
        }
    }

    var ratings: Set<String> {
        get {
            var filteredRatings = Set<String>()
            for ratingToken in queryTokens.filter(column: Column.rating) {
                filteredRatings.insert(ratingToken.value)
            }
            return filteredRatings
        }

        set(newValue) {
            queryTokens.removeAll(column: Column.rating)
            for rating in newValue { queryTokens.insert(column: Column.rating, value: rating) }
        }
    }

    var openAt: String {
        get {
            guard let openAtQueryToken = queryTokens.filter(column: Column.openAt).first else { return "" }
            return openAtQueryToken.value
        }

        set(newValue) {
            queryTokens.removeAll(column: Column.openAt)
            queryTokens.insert(column: Column.openAt, value: newValue)
        }
    }

    var wifi: Bool {
        get {
            guard let wifiQueryToken = queryTokens.filter(column: Column.wifi).first else { return false }
            return wifiQueryToken.value == "true"
        }

        set(newValue) {
            queryTokens.removeAll(column: Column.wifi)
            if newValue == true {
                queryTokens.insert(column: Column.wifi, value: "\(newValue)")
            }
        }
    }

    var creditCard: Bool {
        get {
            guard let creditCardQueryToken = queryTokens.filter(column: Column.creditCard).first else { return false }
            return creditCardQueryToken.value == "true"
        }

        set(newValue) {
            queryTokens.removeAll(column: Column.creditCard)
            if newValue == true {
                queryTokens.insert(column: Column.creditCard, value: "\(newValue)")
            }
        }
    }

    var search: String {
        get {
            guard let searchQueryToken = queryTokens.filter(column: Column.search).first else { return "" }
            return searchQueryToken.value
        }

        set(newValue) {
            queryTokens.removeAll(column: Column.search)
            queryTokens.insert(column: Column.search, value: newValue)
        }
    }

    init(queryTokens: URLQueryTokens) {
        self.queryTokens = queryTokens
    }
}
