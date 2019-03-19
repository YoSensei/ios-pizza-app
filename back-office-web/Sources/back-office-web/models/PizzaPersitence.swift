import Foundation
import CouchDB
import LoggerAPI

extension Pizza {
    // 1
    class Persistence {
        // 2
        static func getAll(from database: Database, callback:
            @escaping (_ pizzas: [Pizza]?, _ error: Error?) -> Void) {
            Log.info("get All pizzas");
            
        }
        
        // 3
        static func save(_ pizza: Pizza, to database: Database, callback:
            @escaping (_ pizza: Pizza?, _ error: Error?) -> Void) {
            // 1
            database.create(pizza) { document, error in
                guard let document = document else {
                    Log.error("Error creating new document: \(String(describing: error))")
                    return callback(nil, error)
                }
                // 2
                database.retrieve(document.id, callback: callback)
            }
        }
        
        // 4
        static func delete(_ pizzaID: String, from database: Database, callback:
            @escaping (_ error: Error?) -> Void) {
            
            
        }
    }
}
