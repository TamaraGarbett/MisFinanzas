import UIKit

class BudgetViewController: BaseViewController {
    @IBOutlet var tableView:UITableView!
    //Creo un array para poner los balances
    var budgets: [Budget] = []
    
    @IBOutlet var btnIncome:UIButton!
    @IBOutlet var btnExpense:UIButton!
    @IBOutlet var searchBar:UISearchBar!
    @IBOutlet var lblBudget:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        budgets = [
            Budget(description: "Ropa", amount: "700"),
            Budget(description: "Caramelos", amount: "100")
        ]
        //Registro la celda adentro de la tabla
        tableView.register(UINib(nibName: "ImporteTableViewCell", bundle: nil), forCellReuseIdentifier: "ImporteTableViewCell")
        //Le digo a la tabla que su dataSource y su delegate son el mismo ViewController
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func btnIncomeAction(){
        self.navigationController?.pushViewController(NewBudgetItemViewController(), animated: true)
    }
    @IBAction func btnExpenseAction(){
        self.navigationController?.pushViewController(NewBudgetItemViewController(), animated: true)
    }
}

struct Budget{
    let description:String
    let amount: String
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
        return budgets.count
    }
    //Cual es la celda que voy a mostrar para cada una de las filas
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Despues de registrarlo puedo desencolar una celda (Para reutilizar)
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImporteTableViewCell") as! ImporteTableViewCell
        //Obtengo el contacto con el row que es la propiedad de la fila
        let budget = budgets[indexPath.row]
        //Lo configuro
        cell.configure(with: budget)
        return cell
    }
    
}

