// 1
import CouchDB
import Foundation
import Kitura
import LoggerAPI

public class App {
    
    // 2
    var client: CouchDBClient?
    var database: Database?
    
    let router = Router()
    
    private func postInit() {
        // 1
        let connectionProperties = ConnectionProperties(host: "localhost",
                                                        port: 5984,
                                                        secured: false)
        client = CouchDBClient(connectionProperties: connectionProperties)
        // 2
        client!.retrieveDB("pizzas") { database, error in
            guard let database = database else {
                // 3
                Log.info("Could not retrieve pizza database: "
                    + "\(String(describing: error?.localizedDescription)) "
                    + "- attempting to create new one.")
                self.createNewDatabase()
                return
            }
            // 4
            Log.info("Acronyms database located - loading...")
            self.finalizeRoutes(with: database)
        }
    }
    
    private func createNewDatabase() {
        // 1
        client?.createDB("pizzas") { database, error in
            // 2
            guard let database = database else {
                Log.error("Could not create new database: "
                    + "(\(String(describing: error?.localizedDescription))) "
                    + "- acronym routes not created")
                return
            }
            self.finalizeRoutes(with: database)
        }
    }
    
    private func finalizeRoutes(with database: Database) {
        self.database = database
        initializeAcronymRoutes(app: self)
        Log.info("Pizzas routes created")

    }
    
    public func run() {
        // 6
        postInit()
        Kitura.addHTTPServer(onPort: 3100, with: router)
        Kitura.run()
    }
}
