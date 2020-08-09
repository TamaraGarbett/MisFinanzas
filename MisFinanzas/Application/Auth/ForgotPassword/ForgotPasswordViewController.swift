import UIKit
//Clase para poder cambiar la contraseña en caso de haberla olvidado.
//Contiene 3 stack que se irán ocualtando y mostrando segun sea necesario para realizar el proceso
class ForgotPasswordViewController: AuthBaseViewController {
    @IBOutlet var stackViewEnterEmail:UIStackView!
    @IBOutlet var txtEmail:UITextField!
    @IBOutlet var lblErrorEmail:UILabel!
    @IBOutlet var btnContinueEmail:UIButton!
    
    @IBOutlet var stackViewEnterAnswer:UIStackView!
    @IBOutlet var txtQuestion:UITextField!
    @IBOutlet var txtAnswer:UITextField!
    @IBOutlet var lblErrorAnswer:UILabel!
    @IBOutlet var btnContinueAnswer:UIButton!
    
    @IBOutlet var stackViewChangePassword:UIStackView!
    @IBOutlet var txtNewPassword:UITextField!
    @IBOutlet var btnConfirm:UIButton!
    
    //Variable de tipo User que contiene al objeto del usuario que quiere cambiar la contraseña
    private var user:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtEmail.attributedPlaceholder = NSAttributedString(string: "Correo electrónico", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        btnContinueEmail.layer.cornerRadius = 5
        btnContinueEmail.layer.borderWidth = 1
        btnContinueEmail.layer.borderColor = UIColor.clear.cgColor
        
        txtAnswer.attributedPlaceholder = NSAttributedString(string: "Respuesta de seguridad", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        btnContinueAnswer.layer.cornerRadius = 5
        btnContinueAnswer.layer.borderWidth = 1
        btnContinueAnswer.layer.borderColor = UIColor.clear.cgColor
        
        txtNewPassword.attributedPlaceholder = NSAttributedString(string: "Nueva contraseña", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        btnConfirm.layer.cornerRadius = 5
        btnConfirm.layer.borderWidth = 1
        btnConfirm.layer.borderColor = UIColor.clear.cgColor
        
        txtQuestion.isEnabled = false

    }
    //Funcion que verifica que el email ingresado por el usuario exista en la BD
    @IBAction func btnContinueEmailAction(){
        self.user = self.manager.fetchUser(email: txtEmail.text!)
        if user == nil{
            lblErrorEmail.isHidden = false
        }else{
            //Si existe el email oculto el stack que contiene el textfield para ingresar el email y muestro el stack que contiene la pregunta de seguridad
            lblErrorEmail.isHidden = true
            stackViewEnterEmail.isHidden = true
            //Muesto en el TextField la pregunta de seguridad del usuario
            txtQuestion.text = user?.question
            stackViewEnterAnswer.isHidden = false
        }
    }
    //Funcion que compara la respuesta de seguridad ingresada con la existente en la BD
    @IBAction func btnContinueAnswerAction(){
        if self.user?.answer == txtAnswer.text{
            //En caso de estar bien, oculto el stack que contiene la respuesta y muestro el stack para cambiar la contraseña
            stackViewEnterAnswer.isHidden = true
            stackViewChangePassword.isHidden = false
            lblErrorAnswer.isHidden = true
        }else{
            lblErrorAnswer.isHidden = false
        }
    }
    //Funcion que lee la nueva contraseña ingresada por el usuario
    @IBAction func btnConfirmAction(){
        //Valido el formato de la contraseña
        if self.validatePassword(password: txtNewPassword.text!){
            //En caso que este bien mando a cambiarla en el Core Data Manager
            self.manager.changePassword(user:user!, newPassword:txtNewPassword.text!)
            print("Nueva contraseña: \(txtNewPassword.text!)")
            self.navigationController?.popViewController(animated: true)
        }else{
            lblErrorEmail.text = "Mínimo 6 carácteres, una mayúscula y un número"
            lblErrorEmail.isHidden = false
        }
    }
}
