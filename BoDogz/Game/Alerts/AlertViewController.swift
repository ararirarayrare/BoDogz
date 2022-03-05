import UIKit

class AlertViewController: BaseViewController {
    
    var text: String!
    var savingDelegate: SavingDelegate?
    
    @IBOutlet weak var labelContainerView: UIView!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.label.text = text
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let deadline = DispatchTime.now() + 0.7
        
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.dismiss(animated: true) {
                guard self.text != Constants.cleaned else { return }
                self.savingDelegate?.dismiss()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setCornerRadiuses()
    }
    
    func setCornerRadiuses() {
        self.labelContainerView.layer.cornerRadius = 10
    }
}
