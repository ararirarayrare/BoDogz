import UIKit

class RemoveAlertViewController: BaseViewController {
    
    var text: String!
    var deleteAction: (()->Void)?
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.label.text = text
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setCornerRadiuses()
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func removeButtonPerssed(_ sender: UIButton) {
        deleteAction?()
        self.dismiss(animated: true)
    }
    
    func setCornerRadiuses() {
        let radius = 10.0
        self.containerView.layer.cornerRadius = radius
        self.cancelButton.layer.cornerRadius = radius
        self.removeButton.layer.cornerRadius = radius
    }
}
