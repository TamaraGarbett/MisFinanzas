import Foundation
class User{
    private var email:String
    private var password:String
    
    func getEmail() -> String{
        return self.email
    }
    func setEmail(newEmail:String){
        self.email = newEmail
    }
    func getPassword() -> String{
        return self.password
    }
    func setPassword(newPassword:String){
        self.password = newPassword
    }
    
    init (email:String, password:String){
        self.email = email
        self.password = password
}
