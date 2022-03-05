import UIKit

class RandomFactViewController: BaseViewController {
    
    var text: String?
    var showFact: Bool = true
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
        self.label.adjustsFontSizeToFitWidth = true
        self.label.minimumScaleFactor = 0.8
    }
    
    private func setup() {
        if showFact {
            self.label.text = text
        } else {
            self.label.text = Constants.factHint
            self.label.font = UIFont(name: "Courier New Bold", size: 20)
            self.label.textAlignment = .center
        }
    }
}
