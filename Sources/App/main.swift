

import Vapor
import VaporSQLite


let drop = Droplet()
try drop.addProvider(VaporSQLite.Provider.self)


drop.get("version") { request in
    
    let result = try drop.database?.driver.raw("SELECT sqlite_version()")
    return try JSON(node :result)
}

drop.post("customers") { request in
    
    guard let firstName = request.json?["firstName"]?.string! else {
        fatalError("firstName is missing")
    }
    
    guard let lastName = request.json?["lastName"]?.string else {
        fatalError("lastName missing")
    }
    
    let result = try drop.database?.driver.raw("INSERT INTO Customers(firstName,lastName) VALUES(?,?)",[firstName,lastName])
    
    return try JSON(node :["success":true])
}


class Customer : NodeRepresentable {
    
    var firstName :String!
    var lastName :String!
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node :["firstName":self.firstName,"lastName":self.lastName])
    }
    
    init(firstName :String, lastName :String) {
        self.firstName = firstName
        self.lastName = lastName
    }
}

drop.post("customer") { request in

    guard let firstName = request.json?["firstName"]?.string! else {
        fatalError("firstName is missing")
    }
    
    guard let lastName = request.json?["lastName"]?.string else {
        fatalError("lastName missing")
    }
    
    return firstName + lastName
}


drop.get("customers") { request in
    
    let customer = Customer(firstName: "Mohammad", lastName: "Azam")
    return try JSON(node :[customer])
}

drop.get("hello") { request in
    return try JSON(node :["message":"Hello Vapor!"])
}

drop.get("customers",Int.self) {  request, id in
    return "The passed id is \(id)"
}


drop.run()
