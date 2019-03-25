// 1
import CouchDB

// 2
struct Pizza: Document {
    // 3
    let _id: String?
    // 4
    var _rev: String?
    
    // 5
    var name: String
    var ingredients: String
}
