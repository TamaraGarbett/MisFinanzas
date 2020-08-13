import UIKit

class ImporteTableViewCell: UITableViewCell {
    static let height: CGFloat = 50.0
    
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var lblAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
//Metodo para configurar el modelo
    func configure(with budget: Budget){
        lblDescription.text = budget.description
        lblAmount.text = budget.amount
    }
    
}
