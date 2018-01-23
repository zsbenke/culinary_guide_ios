import Foundation

let currentDate = Date()
let formatter = DateFormatter()
formatter.dateFormat = "yyyy-MM-dd HH:mm"
let dateFormatted = formatter.string(from: currentDate)
