import Foundation
import CoreData

@objc(Importe)
public class Importe: NSManagedObject{
    //Funcion para comprobar si dos importes son iguales
        static func == (lhs: Importe, rhs: Importe) -> Bool {
            if lhs.date != rhs.date {
                return false
            }
            if lhs.description != rhs.description {
                return false
            }
            if lhs.amount != rhs.amount {
                return false
            }
            if lhs.category != rhs.category {
                return false
            }
            if lhs.fixedCost != rhs.fixedCost {
                return false
            }
            if lhs.type != rhs.type {
                return false
            }
            if lhs.userEmail != rhs.userEmail {
                return false
            }
            
            return true
    }
    

}
