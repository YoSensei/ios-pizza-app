import Kitura
import LoggerAPI

public class App {
    
    // 1
    let router = Router()
    
    public func run() {
        // 2
        Kitura.addHTTPServer(onPort: 3100, with: router)
        // 3
        Kitura.run()
    }
}

