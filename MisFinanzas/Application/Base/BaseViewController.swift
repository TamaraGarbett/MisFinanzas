import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init() {
        super.init(
            nibName: String(describing: type(of: self)),
            bundle: nil
        )
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
}