// 1
import CouchDB

// 2
struct Order: Document {
    // 3
    let _id: String?
    // 4
    var _rev: String?
    // 5
    var owner: String
    var pizzas: [Pizza]
    var status: String
}

