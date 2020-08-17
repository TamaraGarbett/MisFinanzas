import Foundation
class BudgetBaseViewController: BaseViewController{
     static var loggedUser:User{
        get{
            return self.loggedUser
        }
        set(newLoggedUser){
            self.loggedUser = newLoggedUser
        }
    }
    
    
}
