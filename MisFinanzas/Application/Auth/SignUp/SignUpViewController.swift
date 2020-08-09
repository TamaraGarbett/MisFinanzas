import UIKit
//Clase para registrar un usuario en el sistema
class SignUpViewController: AuthBaseViewController{
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
        //Llamo a las funciones EditingDidEnd de cada TextField para que comprueben su contenido a la hora de registrar al usuario
        txtEmailEditingDidEnd(txtEmail)
        txtPasswordEditingDidEnd(txtPassword)
        txtQuestionEditingDidEnd(txtQuestion)
        txtAnswerEditingDidEnd(txtAnswer)
        
        //Si todos los campos del TextField estan bien
        if isEmailOk && isPasswordOk && isQuestionOk && isAnswerOk{
            //Verifico que el email ingresado no este registrado en el sistema
            if self.manager.fetchUser(email: txtEmail.text!) != nil {
                lblErrorEmail.text = "El email ya está registrado en el sistema"
                lblErrorEmail.isHidden = false
                return
            }
            //Mando a crear al usuario al Core Data Manager
            self.manager.createUser(email: txtEmail.text!, password: txtPassword.text!, question: txtQuestion.text!, answer: txtAnswer.text!)
            print("Email: \(txtEmail.text!)\nContraseña: \(txtPassword.text!)\nPregunta: \(txtQuestion.text!)\nRespuesta: \(txtAnswer.text!)")
            //Saco de la cola la pantalla actual para volver al login
            self.navigationController?.popViewController(animated: true)
        } else {
            lblError.isHidden = false
        }
    }
    //INICIO: Funciones para verificar el contenido de los campos de TextField
    @IBAction func txtEmailEditingDidEnd(_ sender: Any) {
        if self.validateEmail(email: txtEmail.text!){
            self.isEmailOk = true
            lblErrorEmail.isHidden = true
            txtEmail.layer.borderWidth = 0
        }else{
            self.isEmailOk = false
            lblErrorEmail.text = "El email ingresado es incorrecto"
            lblErrorEmail.isHidden = false
            txtEmail.layer.borderWidth = 1
        }
    }
    
    @IBAction func txtPasswordEditingDidEnd(_ sender: Any) {
        if self.validatePassword(password: txtPassword.text!){
            self.isPasswordOk = true
            lblErrorPassword.isHidden = true
            txtPassword.layer.borderWidth = 0
        }else{
            self.isPasswordOk = false
            lblErrorPassword.isHidden = false
            txtPassword.layer.borderWidth = 1
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
    //FIN: Funciones para verificar el contenido de los campos de TextField
}
