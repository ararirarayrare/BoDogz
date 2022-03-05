import UIKit

class CreateReminderViewController: BaseViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var selectedDogLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var topGestureZone: UIView!
    @IBOutlet weak var bottomGestureZone: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextField.delegate = self
        requestAuthorization()
        self.hideKeyboardWhenTappedAround()
        setupGestures()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setCornerRadiuses()
    }
    

    
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismissWithAnimation()
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        if descriptionTextField.text != "" && selectedDogLabel.text != "select dog" {
            
            guard let title = selectedDogLabel.text else { return }
            guard let body = descriptionTextField.text else { return }
            
            NotificationManager.shared.addNotification(title: title, body: body, date: self.datePicker.date)
                
            let alert = AlertService.shared.alert(Constants.reminderAdded)
            alert.savingDelegate = self
            
            present(alert, animated: true)
        }
    }
    
    @objc private func selectDogTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = String(describing: DogSelectorTableViewController.self)
        guard let dogSelectorViewController = storyboard.instantiateViewController(withIdentifier: identifier) as? DogSelectorTableViewController else { return }
        
        dogSelectorViewController.modalPresentationStyle = .popover
        
        let popOverViewContoller = dogSelectorViewController.popoverPresentationController
        popOverViewContoller?.delegate = self
        
        popOverViewContoller?.sourceView = self.selectedDogLabel
        dogSelectorViewController.preferredContentSize = CGSize(width: 250, height: 250)
        
        dogSelectorViewController.selectionDelegate = self
        
        self.present(dogSelectorViewController, animated: true)
    }
    
    @objc private func tappedTop()  {
        dismissWithAnimation()
    }
    
    @objc private func tappedBottom()  {
        dismissWithAnimation()
    }
    
    private func requestAuthorization() {
        NotificationManager.shared.requestAuthorization { granted in
            if !granted {
                self.pushSettingsAlert()
            }
        }
    }
    
    private func pushSettingsAlert() {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: Constants.notificationAlertTitle, message: Constants.notificationAlertMessage, preferredStyle: .alert)
            
            let goToSettings = UIAlertAction(title: "Settings", style: .default) { _ in
                guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
                self.dismiss(animated: false)
                if UIApplication.shared.canOpenURL(settingsURL) {
                    UIApplication.shared.open(settingsURL)
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                self.dismissWithAnimation()
            }
            
            alertController.addAction(goToSettings)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func dismissWithAnimation() {
        UIView.animate(withDuration: 0.15) {
            self.view.backgroundColor = .clear
        } completion: { _ in
            self.dismiss(animated: true)
        }
    }
    
    private func setCornerRadiuses() {
        self.containerView.layer.cornerRadius = 20
        self.cancelButton.layer.cornerRadius = 10
        self.addButton.layer.cornerRadius = 10
    }
    
    private func setupGestures() {
        let selectGesture = UITapGestureRecognizer(target: self, action: #selector(selectDogTapped))
        selectGesture.numberOfTapsRequired = 1
        self.selectedDogLabel.isUserInteractionEnabled = true
        self.selectedDogLabel.addGestureRecognizer(selectGesture)
        
        let topGesture = UITapGestureRecognizer(target: self, action: #selector(tappedTop))
        topGesture.numberOfTapsRequired = 1
        self.topGestureZone.isUserInteractionEnabled = true
        self.topGestureZone.addGestureRecognizer(topGesture)
        
        let bottomGesture = UITapGestureRecognizer(target: self, action: #selector(tappedBottom))
        bottomGesture.numberOfTapsRequired = 1
        self.bottomGestureZone.isUserInteractionEnabled = true
        self.bottomGestureZone.addGestureRecognizer(bottomGesture)
    }
}

extension CreateReminderViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension CreateReminderViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
}


extension CreateReminderViewController: SelectDogDelegate, SavingDelegate {
    func set(name: String) {
        self.selectedDogLabel.text = name
    }
    
    func dismiss() {
        self.dismissWithAnimation()
    }
}

