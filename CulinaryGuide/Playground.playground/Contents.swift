import Foundation
import QuartzCore

func executionTimeInterval(block: () -> ()) -> CFTimeInterval {
    let start = CACurrentMediaTime()
    block();
    let end = CACurrentMediaTime()
    return end - start
}

let currentDate = Date()
let formatter = DateFormatter()
formatter.dateFormat = "yyyy-MM-dd HH:mm"
let dateFormatted = formatter.string(from: currentDate)

Date().timeIntervalSince1970

struct TestStruct {
    var name: String
    var column: String
}

let arrayOfItems = [
    TestStruct(name: "test 1", column: "column 1"),
    TestStruct(name: "test 2", column: "column 1"),
    TestStruct(name: "test 3", column: "column 1"),
    TestStruct(name: "test 4", column: "column 2"),
    TestStruct(name: "test 5", column: "column 2"),
    TestStruct(name: "test 6", column: "column 2"),
    TestStruct(name: "test 7", column: "column 2")
]

var dictionaryOfItems = [
    "column 1": [TestStruct](),
    "column 2": [TestStruct]()
]

for item in arrayOfItems {
    switch item.column {
    case "column 1":
        dictionaryOfItems["column 1"]?.append(item)
    case "column 2":
        dictionaryOfItems["column 2"]?.append(item)
    default:
        break
    }
}

executionTimeInterval {
    let something = dictionaryOfItems["column 2"]
    something
}

executionTimeInterval {
    let items = arrayOfItems.filter { $0.column == "column 2" }
    items
}
