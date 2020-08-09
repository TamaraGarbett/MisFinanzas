import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var answer: String?
    @NSManaged public var email: String?
    @NSManaged public var password: String?
    @NSManaged public var question: String?

}
