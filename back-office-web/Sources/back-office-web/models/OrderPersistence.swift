import Foundation
import CouchDB
import LoggerAPI

extension Order {
    // 1
    class Persistence {
        // 2
        static func getAll(from database: Database, callback:
            @escaping (_ orders: [Order]?, _ error: Error?) -> Void) {
            Log.info("get All order");
            database.retrieveAll(includeDocuments: true) { documents, error in
                guard let documents = documents else {
                    Log.error("Error retrieving all documents: \(String(describing: error))")
                    return callback(nil, error)
                }
                //2
                let orders = documents.decodeDocuments(ofType: Order.self)
                callback(orders, nil)
            }
            
        }
        
        static func save(_ order: Order, to database: Database, callback:
            @escaping (_ order: Order?, _ error: Error?) -> Void) {
            // 1
            database.create(order) { document, error in
                guard let document = document else {
                    Log.error("Error creating new document: \(String(describing: error))")
                    return callback(nil, error)
                }
                // 2
                database.retrieve(document.id, callback: callback)
            }
        }
    }
}

