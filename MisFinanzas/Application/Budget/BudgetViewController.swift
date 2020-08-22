import UIKit

class BudgetViewController: BaseViewController {
    @IBOutlet var tableView:UITableView!
    //Creo un array para poner los balances
    var budgets: [Budget] = []
    
    static var loggedUser:User?
    let defaults = UserDefaults.standard
    
    @IBOutlet var btnIncome:UIButton!
    @IBOutlet var btnExpense:UIButton!
    @IBOutlet var searchBar:UISearchBar!
    @IBOutlet var lblBudget:UILabel!
    
    var filteredBudget:[Budget] = []
    var resultSearchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BudgetViewController.loggedUser = self.manager.fetchUser(email: defaults.string(forKey: "LoggedUser")!)
        //Registro la celda adentro de la tabla
        tableView.register(UINib(nibName: "ImporteTableViewCell", bundle: nil), forCellReuseIdentifier: "ImporteTableViewCell")
        //Le digo a la tabla que su dataSource y su delegate son el mismo ViewController
        tableView.delegate = self
        tableView.dataSource = self
        
        //Reemplazo el botón Back por Log Out para cerrar sesión
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Log out", style: UIBarButtonItemStyle.plain, target: self, action: #selector(BudgetViewController.back))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        //Creo el UISearchController
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            //Lo adjunto a la NavigationBar
            controller.hidesNavigationBarDuringPresentation = false
            controller.searchBar.searchBarStyle = .minimal
            self.navigationItem.titleView = controller.searchBar
            self.definesPresentationContext = true
            
            return controller
        })()
        
    }
    
    @objc func back(){
        //Creo el UIAlertController con sus parámetros
        let refreshAlert = UIAlertController(title: "Cerrar sesión", message: "¿Está seguro que quiere cerrar sesión?", preferredStyle: UIAlertControllerStyle.alert)
        
        //Le añado las acciones Sí y No
        refreshAlert.addAction(UIAlertAction(title: "Sí", style: .default, handler: { (action: UIAlertAction!) in
            //Borro el valor de la key LoggedUser para que no vuelva a iniciar sesión automáticamente
            self.defaults.removeObject(forKey: "LoggedUser")
            //Vuelvo a LoginViewController
            self.navigationController?.popViewController(animated: true)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            return
        }))
        
        //Muestro la alerta
        self.navigationController?.viewControllers.last!.present(refreshAlert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        budgets.removeAll()
        var budget = 0.0
        //Creo de nuevo el core data manager para que se actualicen los datos
        self.manager = CoreDataManager()
        //Actualizo el usuario loggeado
        BudgetViewController.loggedUser = self.manager.fetchUser(email: UserDefaults.standard.string(forKey:"LoggedUser")!)
        //Traigo todos los importes del usuario loggeado
        let listaImportes = BudgetViewController.loggedUser?.importes?.allObjects as! [Importe]
        //Recorro la lista de importes para llenar el array a mostrar en la tabla
        for importe in listaImportes{
            let type = importe.type
            let description = importe.descriptionImporte!
            let amount = String(format: "%.2f", importe.amount)
            if type == TypeImporte.gasto.rawValue {
                budget -= importe.amount
            }else{
                budget += importe.amount
            }
            let df = DateFormatter()
            df.dateFormat = "dd/MM/yyyy"
            let date = df.string(from: importe.date!)
            budgets.append(Budget(type:type, description: description, amount: amount, date: date))
        }
        
        filteredBudget = budgets
        //Refresco la tabla
        self.tableView.reloadData()
        //Muestro en el label el balance total
        lblBudget.text = "Balance total = \(String(format: "%.2f", budget))"
        if budget < 0{
            lblBudget.textColor = UIColor.red
        }else if budget > 0{
            lblBudget.textColor = UIColor(red:0, green:0.56, blue:0.22, alpha:1)
        }else{
            lblBudget.textColor = UIColor.white
        }
    }
    //Segun el boton que se presione, se cambia el tipo de importe en newBudgetItemViewController y se muestra la pantalla
    @IBAction func btnIncomeAction(){
        let newBudgetItemViewController = NewBudgetItemViewController()
        newBudgetItemViewController.type = .ingreso
        self.navigationController?.pushViewController (newBudgetItemViewController, animated: true)
    }
    @IBAction func btnExpenseAction(){
        let newBudgetItemViewController = NewBudgetItemViewController()
        newBudgetItemViewController.type = .gasto
        self.navigationController?.pushViewController (newBudgetItemViewController, animated: true)
    }
}
//struct que contiene los atributos de los importes a mostrar en la tabla
struct Budget{
    let type:Int32
    let description:String
    let amount:String
    let date:String
}

extension BudgetViewController: UITableViewDelegate {
    //Asigno la altura para cada una de las filas como una constante (en este caso la static del ImporteTableViewCell)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ImporteTableViewCell.height
    }
}

extension BudgetViewController: UITableViewDataSource {
    //Metodo opcional para el numero de secciones, por defecto es 1
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //Funcion que asigna la cantidad de filas en una seccion
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return budgets.count
        
        if(resultSearchController.isActive){
            return filteredBudget.count
        } else {
            return budgets.count
        }
    }
    
    //Cual es la celda que voy a mostrar para cada una de las filas
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Despues de registrarlo puedo desencolar una celda (Para reutilizar)
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImporteTableViewCell", for: indexPath) as! ImporteTableViewCell
        
        if (resultSearchController.isActive) {
            //Lo configuro
            cell.configure(with: filteredBudget[indexPath.row])
        }
        else {
            cell.configure(with: budgets[indexPath.row])
        }
        return cell
    }
    
}

extension BudgetViewController: UISearchResultsUpdating{
    
    //Filtro el array de budget basandome en el texto ingresado en la SearchBar
    func updateSearchResults(for searchController: UISearchController) {
        filteredBudget.removeAll(keepingCapacity: false)
        //Si está vacío el texto en la searchbar muestro todos los importes
        if searchController.searchBar.text! == "" {
            filteredBudget = budgets
        } else {
            let array = budgets.filter { budget in
                return budget.description.lowercased().contains(searchController.searchBar.text!.lowercased())
            }
            filteredBudget = array
        }
        self.tableView.reloadData()
    }
}

