import UIKit

class LoginViewController: BaseViewController {

    @IBOutlet var txtEmail:UITextField!
    @IBOutlet var txtPassword:UITextField!
    @IBOutlet var btnLogin:UIButton!
    @IBOutlet var lblError:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtEmail.attributedPlaceholder = NSAttributedString(string: "Correo electrónico", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        txtPassword.attributedPlaceholder = NSAttributedString(string: "Contraseña", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        btnLogin.layer.cornerRadius = 5
        btnLogin.layer.borderWidth = 1
        btnLogin.layer.borderColor = UIColor.clear.cgColor
        
    }
    
    @IBAction func btnLogin_Action(){
        let user = self.manager.fetchUser(email: txtEmail.text!)
        if user == nil{
            print("Usuario no esta en el sistema")
            lblError.isHidden = false
        }else if user?.password == txtPassword.text{
            print("Usuario ingreso al sistema")
        }else{
            lblError.isHidden = false
        }
    }
    
    
    @IBAction func btnForgotPassword(){
        self.navigationController?.pushViewController(ForgotPasswordViewController(), animated: true)
    }
    
    @IBAction func btnSignUp(){
        self.navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
    
    
}
