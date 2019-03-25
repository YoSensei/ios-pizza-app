import CouchDB
import Kitura
import KituraContracts
import LoggerAPI

private var database: Database?

func initializeAcronymRoutes(app: App) {
    database = app.database
    
    app.router.get("api/orders", handler: getOrders)
    app.router.post("api/orders", handler: addOrder)
    app.router.post("api/pizzas", handler: addPizza)
    // app.router.get("/pizzas/create", handler: addPizzaFrontGet)
    
    app.router.get("/pizzas/create") { _, response, next in
        
        Log.info("pizza front")
        let context: [String: [[String:Any]]] =
            [
                "articles": [
                    ["title" : "Using Stencil with Swift", "author" : "IBM Swift"],
                    ["title" : "Server-Side Swift with Kitura", "author" : "Kitura"],
                ]
        ]
        try response.render("PizzaCreate.stencil", context: context)
        response.status(.OK)
        next()
    }
    
    app.router.all("/pizzas/create", middleware: BodyParser())
    app.router.post("/pizzas/create", handler: addPizzaFrontPost)
    app.router.get("/pizzas/orders", handler: ordersGet)
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

func addPizzaFrontPost(request: RouterRequest,
                response: RouterResponse, next: @escaping () -> Void) {
    guard let values = request.body else {
        print("here")
        response.send("fail");
        return
    }
    let name = values.asURLEncoded!["name"]!
    let ingredients = values.asURLEncoded!["ingredients"]!
    
    print(ingredients)
    print(name)
    
    let pizza = Pizza(_id: nil, _rev: nil, name: name, ingredients: ingredients)
    
    
    Pizza.Persistence.save(pizza, to: database!) { newPizza, error in
        response.send("ok")
        next()
        return;
    }
    
}

func ordersGet(request: RouterRequest,
                       response: RouterResponse, next: @escaping () -> Void ) {
    
    Order.Persistence.getAll(from: database!) { orders, error in
        
        do {
            let context: [String: [Any]] = [
                "orders": orders!,
                "tableHeaders": ["ok", "ok", "ok", "actions"]
            ]
            print(context)
            try response.render("Orders.stencil", context: context)
            next()
            return
        } catch {
            response.send("error")
            next()
            return
        }

    }
}



