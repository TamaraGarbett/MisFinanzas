import UIKit

class ImporteTableViewCell: UITableViewCell {
    static let height: CGFloat = 50.0
    
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var lblAmount: UILabel!
    @IBOutlet var lblDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
//Metodo para configurar el modelo
    func configure(with budget: Budget){
        if budget.type == 0{
            lblAmount.textColor = UIColor.red
        } else {
            lblAmount.textColor = UIColor.green
        }
        lblDescription.text = budget.description
        lblAmount.text = "$\(budget.amount)"
        lblDate.text = budget.date
    }
    
}
