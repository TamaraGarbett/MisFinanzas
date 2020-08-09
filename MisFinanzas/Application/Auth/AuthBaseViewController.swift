import Foundation
//Esta clase va a ser usada como superclase en los viewController relacionados con la autenticacion de usuarios
//Contiene metodos para validar el formato de email y contraseña que son usados a la hora de autenticar un usuario en todos los viewController relacionados con esto
class AuthBaseViewController:BaseViewController{
    //Esta funcion verifica que la contraseña ingresada por el usuario este en el formato correcto pedido (minimo 6 caracteres, una mayuscula y un numero) mediante el uso
    //de una expresion regular. La funcion recibe por parametro la contraseña ingresada por el usuario.
    //Devuelve true en caso que este correcto y false en caso de que no.
    func validatePassword(password:String) -> Bool{
        let range = NSRange(location:0, length:password.utf16.count)
        let regex = try! NSRegularExpression(pattern:"^(?=.*\\d)(?=.*[A-Z])(?=.*[a-zA-Z]).{6,}$")
        if regex.firstMatch(in:password,options:[], range:range) == nil{
            return false
        }else{
            return true
        }
    }
    //Esta funcion verifica que el email ingresado por el usuario sea valido, mediante el uso de una expresión regular.
    //La función recibe por parametro el email ingresado por el usuario. Devuelve true en caso de estar correcto y false en caso de que no.
    func validateEmail(email:String) -> Bool{
        let range = NSRange(location:0, length:email.utf16.count)
        let regex = try! NSRegularExpression(pattern:"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
        if regex.firstMatch(in:email, options:[], range:range) == nil{
            return false
        }else{
            return true
        }
    }
}

