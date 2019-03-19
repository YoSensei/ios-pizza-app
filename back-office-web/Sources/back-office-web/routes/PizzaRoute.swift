import CouchDB
import Kitura
import KituraContracts
import LoggerAPI

// 1
private var database: Database?

func initializeAcronymRoutes(app: App) {
    // 2
    database = app.database
    // 3
    app.router.get("/orders", handler: getOrders)
    app.router.post("/orders", handler: addOrder)
    app.router.post("/pizzas", handler: addPizza)
}

// 4
private func getOrders(completion: @escaping ([Order]?,
    RequestError?) -> Void) {
    
        guard let database = database else {
            return completion(nil, .internalServerError)
        }

        Order.Persistence.getAll(from: database) { orders, error in
            return completion(orders, error as? RequestError)
        }
}

private func addPizza(pizza: Pizza, completion: @escaping (Pizza?,
    RequestError?) -> Void) {
    
    Log.info("pizza saving");
    Log.info(pizza.name);
    
    guard let database = database else {
        return completion(nil, .internalServerError)
    }
    Pizza.Persistence.save(pizza, to: database) { newPizza, error in
        return completion(newPizza, error as? RequestError)
    }
    
}

private func addOrder(order: Order, completion: @escaping (Order?,
    RequestError?) -> Void) {
    
    Log.info("order saving");
    Log.info(order.status);
    
    guard let database = database else {
        return completion(nil, .internalServerError)
    }
    Order.Persistence.save(order, to: database) { newOrder, error in
        return completion(newOrder, error as? RequestError)
    }
    
}


