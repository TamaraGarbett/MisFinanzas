import UIKit

class SignUpViewController: BaseViewController {
    @IBOutlet var txtEmail:UITextField!
    @IBOutlet var txtPassword:UITextField!
    @IBOutlet var txtQuestion:UITextField!
    @IBOutlet var txtAnswer:UITextField!
    @IBOutlet var btnSignUp:UIButton!
    @IBOutlet var lblError:UILabel!
    
    @IBOutlet var lblErrorEmail:UILabel!
    @IBOutlet var lblErrorPassword:UILabel!
    @IBOutlet var lblErrorQuestion:UILabel!
    @IBOutlet var lblErrorAnswer:UILabel!
    
    private var isEmailOk:Bool = false
    private var isPasswordOk:Bool = false
    private var isQuestionOk:Bool = false
    private var isAnswerOk:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtEmail.attributedPlaceholder = NSAttributedString(string: "Correo electrónico", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        txtPassword.attributedPlaceholder = NSAttributedString(string: "Contraseña", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        txtQuestion.attributedPlaceholder = NSAttributedString(string: "Pregunta de seguridad", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        txtAnswer.attributedPlaceholder = NSAttributedString(string: "Respuesta de seguridad", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        btnSignUp.layer.cornerRadius = 5
        btnSignUp.layer.borderWidth = 1
        btnSignUp.layer.borderColor = UIColor.clear.cgColor
        
        txtEmail.layer.borderColor = UIColor.red.cgColor
        txtPassword.layer.borderColor = UIColor.red.cgColor
        txtQuestion.layer.borderColor = UIColor.red.cgColor
        txtAnswer.layer.borderColor = UIColor.red.cgColor
    }
    
    @IBAction func btnSignUp_Action(){
        if isEmailOk && isPasswordOk && isQuestionOk && isAnswerOk{
            
            let user = self.manager.fetchUser(email: txtEmail.text!, password: nil)
            if user != nil {
                lblErrorEmail.text = "El email ya está registrado en el sistema"
                lblErrorEmail.isHidden = false
                return
            }
            self.manager.createUser(email: txtEmail.text!, password: txtPassword.text!, question: txtQuestion.text!, answer: txtAnswer.text!)
            self.navigationController?.popViewController(animated: true)
        } else {
            lblError.isHidden = false
        }
    }
    
    @IBAction func txtEmailEditingDidEnd(_ sender: Any) {
        let range = NSRange(location:0, length:txtEmail.text!.utf16.count)
        let regex = try! NSRegularExpression(pattern:"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
        if regex.firstMatch(in:txtEmail.text!, options:[], range:range) == nil{
            self.isEmailOk = false
            lblErrorEmail.text = "El email ingresado es incorrecto"
            lblErrorEmail.isHidden = false
            txtEmail.layer.borderWidth = 1
        }else{
            self.isEmailOk = true
            lblErrorEmail.isHidden = true
            txtEmail.layer.borderWidth = 0
        }
    }
    
    @IBAction func txtPasswordEditingDidEnd(_ sender: Any) {
        let range = NSRange(location:0, length:txtPassword.text!.utf16.count)
        let regex = try! NSRegularExpression(pattern:"^(?=.*\\d)(?=.*[A-Z])(?=.*[a-zA-Z]).{6,}$")
        if regex.firstMatch(in:txtPassword.text!,options:[], range:range) == nil{
            self.isPasswordOk = false
            lblErrorPassword.isHidden = false
            txtPassword.layer.borderWidth = 1
        }else{
            self.isPasswordOk = true
            lblErrorPassword.isHidden = true
            txtPassword.layer.borderWidth = 0
        }
        
    }
    
    @IBAction func txtQuestionEditingDidEnd(_ sender: Any) {
        if txtQuestion.text!.count >= 1{
            isQuestionOk = true
            lblErrorQuestion.isHidden = true
            txtQuestion.layer.borderWidth = 0
        }else{
            isQuestionOk = false
            lblErrorQuestion.isHidden = false
            txtQuestion.layer.borderWidth = 1
        }
    }
    @IBAction func txtAnswerEditingDidEnd(_ sender: Any) {
        if txtAnswer.text!.count >= 1{
            isAnswerOk = true
            lblErrorAnswer.isHidden = true
            txtAnswer.layer.borderWidth = 0
        }else{
            isAnswerOk = false
            lblErrorAnswer.isHidden = false
            txtAnswer.layer.borderWidth = 1
        }
    }
    
}
