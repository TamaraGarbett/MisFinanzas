import Foundation
import CoreData


extension Importe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Importe> {
        return NSFetchRequest<Importe>(entityName: "Importe")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var descriptionImporte: String?
    @NSManaged public var amount: Double
    @NSManaged public var category: String?
    @NSManaged public var fixedCost: Bool
    @NSManaged public var type: String?
    @NSManaged public var userEmail: String?

}
