import UIKit
//Esta clase es la pantalla de inicio de sesion. Contiene los botones para iniciar sesion, para registrarse y para recuperar la contraseña.
class LoginViewController: AuthBaseViewController {

    @IBOutlet var txtEmail:UITextField!
    @IBOutlet var txtPassword:UITextField!
    @IBOutlet var btnLogin:UIButton!
    @IBOutlet var lblError:UILabel!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Verifico si ya existe un usuario logeado para iniciar sesión automáticamente
        if let _ = defaults.string(forKey: "LoggedUser"){
            self.navigationController?.pushViewController(BudgetViewController(), animated: true)
        }
        
        txtEmail.attributedPlaceholder = NSAttributedString(string: "Correo electrónico", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        txtPassword.attributedPlaceholder = NSAttributedString(string: "Contraseña", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        btnLogin.layer.cornerRadius = 5
        btnLogin.layer.borderWidth = 1
        btnLogin.layer.borderColor = UIColor.clear.cgColor
        //self.manager.clearDataBase(entity: "Importe")
        
    }
    //Esta funcion lee los datos ingresados por el usuario y en caso que sean correctos permite el ingreso al sistema
    @IBAction func btnLogin_Action(){
        if self.manager.authentication(email: txtEmail.text!, password: txtPassword.text!){
            //Guardo al usuario logeado
            defaults.set(txtEmail.text!, forKey: "LoggedUser")
            self.navigationController?.pushViewController(BudgetViewController(), animated: true)
            clean()
        }else{
            print("Usuario no ingreso al sistema")
            lblError.isHidden = false
        }
        print("Email: \(txtEmail.text!)\nContraseña: \(txtPassword.text!)")
    }
    
    //Funcion que abre la pantalla ForgotPasswordViewController
    @IBAction func btnForgotPassword(){
        self.navigationController?.pushViewController(ForgotPasswordViewController(), animated: true)
        clean()
    }
    //Funcion que abre la pantalla SignUpViewController
    @IBAction func btnSignUp(){
        self.navigationController?.pushViewController(SignUpViewController(), animated: true)
        clean()
    }
    
    //Funcion para limpiar los campos y ocultar el mensaje de error
    func clean(){
        txtEmail.text = ""
        txtPassword.text = ""
        lblError.isHidden = true
    }
    
}
