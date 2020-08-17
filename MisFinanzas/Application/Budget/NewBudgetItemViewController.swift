import UIKit
import AKMaskField

class NewBudgetItemViewController: BaseViewController{
    @IBOutlet var lblAmount:UILabel!
    @IBOutlet var lblSymbolPesos:UILabel!
    @IBOutlet var txtAmount:UITextField!
    @IBOutlet var lblFixedCost:UILabel!
    @IBOutlet var switchFixedCost:UISwitch!
    @IBOutlet var txtDate:AKMaskField!
    @IBOutlet var txtDescription:UITextField!
    @IBOutlet var btnCategory:UIButton!
    @IBOutlet var stackCategoryExpense:UIStackView!
    @IBOutlet var stackCategoryIncome:UIStackView!
    @IBOutlet var viewNewBudget:UIView!
    @IBOutlet var lblError:UILabel!
    
    //Variable que almacena el entero de la categoría, por defecto 0 (Varios)
    var category:Int32 = 0
    //Variable que define el tipo de importe, por defecto Gasto
    var type:TypeImporte = .gasto
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Si el tipo es Gasto pongo el fondo rojo
        if type == .gasto{
            self.viewNewBudget.backgroundColor = UIColor.red
            self.lblAmount.text = "Monto de gasto"
        }else{
            //Si es Ingreso lo hago verde
            self.viewNewBudget.backgroundColor = UIColor(red:0, green:0.56, blue:0.22, alpha:1)
            self.lblAmount.text = "Monto de ingreso"
        }
        
        btnCategory.layer.cornerRadius = 5
        
        //Agrego un botón a la NavBar para guardar el importe
        let rightButtonItem = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(NewBudgetItemViewController.rightButtonAction))
        self.navigationItem.rightBarButtonItem = rightButtonItem
        
        //Le asigno una máscara al TextField de la fecha
        txtDate.maskExpression = "{dd}/{dd}/{dddd}"
        //Obtengo la fecha del día y la cargo en el campo de la fecha
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        let date = df.string(from: Date())
        txtDate.text = date
    }
    
    //Función para ocultar/mostrar el stack de la categoría. Según el tipo de Importe se muestra las categorías de Gasto o Ingreso
    @IBAction func showCategoryMenu(){
        if type == .gasto{
            stackCategoryExpense.isHidden = !stackCategoryExpense.isHidden
        }else{
            stackCategoryIncome.isHidden = !stackCategoryIncome.isHidden
        }
    }
    
    //Función para seleccionar la categoría desde el stack. Se actualiza el label del botón Categoría y se actualiza la variable category con su respectivo entero
    @IBAction func selectCategory(sender: UIButton){
        let title = sender.titleLabel?.text
        btnCategory.setTitle(title, for: .normal)
        
        switch title{
        case "Alimentos"?:
            category = CategoryExpense.alimentos.rawValue
            break
        case "Educación"?:
            category = CategoryExpense.educacion.rawValue
            break
        case "Entretenimiento"?:
            category = CategoryExpense.entretenimiento.rawValue
            break
        case "Facturas"?:
            category = CategoryExpense.facturas.rawValue
            break
        case "Hogar"?:
            category = CategoryExpense.hogar.rawValue
            break
        case "Ropa"?:
            category = CategoryExpense.ropa.rawValue
            break
        case "Salud"?:
            category = CategoryExpense.salud.rawValue
            break
        case "Transporte"?:
            category = CategoryExpense.transporte.rawValue
            break
        case "Varios"?:
            category = CategoryExpense.varios.rawValue
            break
        case "Inversiones"?:
            category = CategoryIncome.inversiones.rawValue
            break
        case "Premios"?:
            category = CategoryIncome.premios.rawValue
            break
        case "Regalos"?:
            category = CategoryIncome.regalos.rawValue
            break
        case "Salario"?:
            category = CategoryIncome.salario.rawValue
            break
        default:
            break
        }
        btnCategory.setTitleColor(UIColor.black, for: .normal)
        showCategoryMenu()
    }
    
    //Función de acción para el botón "Done" de la NavBar. Comprueba los campos ingresados y manda a crear al importe
    @objc func rightButtonAction(sender: UIBarButtonItem){
        let dateString = txtDate.text!
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "dd/MM/yyyy"
        
        //Compruebo si la fecha es correcta
        if let date = dateStringFormatter.date(from: dateString){
            lblError.isHidden = true
            //Compruebo si el monto es correcto al intentar parsearlo a Double. Si devuelve nil, hay un error. Lo formateo a 2 decimales
            if let doubleAmount = Double(String(format: "%.2f", txtAmount.text!)){
                lblError.isHidden = true
                //Sólo permito que el monto sea mayor a 0
                if doubleAmount > 0{
                    lblError.isHidden = true
                    //Si el campo Descripción está vacío (le hago trimming para evitar que acepte sólo espacios)...
                    if txtDescription.text?.trimmingCharacters(in: .whitespaces) == ""{
                        //Y la categoría no se seleccionó (que por defecto es 0 o "Varios")...
                        if btnCategory.titleLabel!.text! == "Categoría"{
                            //Asigno que la descripción del Importe sea Varios
                            txtDescription.text = "Varios"
                        //Si la categoría se seleccionó, la descripción del Importe es el nombre de la categoría seleccionada
                        }else{
                            txtDescription.text = btnCategory.titleLabel!.text!
                        }
                    }
                    //Llamo al manager para que cree el importe en la base de datos, pasándole como parámetro lo ingresado por el usuario
                    self.manager.createImporte(amount: doubleAmount, date: date, descriptionImporte: txtDescription.text!.trimmingCharacters(in: .whitespaces), type: type.rawValue, fixedCost: switchFixedCost.isOn, category: category)
                    //Vuelvo a la vista anterior
                    self.navigationController?.popViewController(animated: true)
                }else{
                    lblError.text = "El monto ingresado debe ser mayor a 0"
                    lblError.isHidden = false
                }
            }else{
                lblError.text = "El monto ingresado es incorrecto"
                lblError.isHidden = false
            }
        }else{
            lblError.text = "La fecha ingresada es incorrecta"
            lblError.isHidden = false
        }
    }

}
