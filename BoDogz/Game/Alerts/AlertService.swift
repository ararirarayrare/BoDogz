import UIKit

struct AlertService {
    
    static let shared = AlertService()
    
    func alert(_ text: String) -> AlertViewController {
        let storyboard = UIStoryboard(name: "Alert", bundle: nil)
        let identifier = String(describing: AlertViewController.self)
        guard let alertViewController = storyboard.instantiateViewController(withIdentifier: identifier) as? AlertViewController else { return AlertViewController()}
        
        alertViewController.text = text
        return alertViewController
    }
    
    func removeAlert(_ text: String, completion: @escaping(() -> Void)) -> RemoveAlertViewController {
        let storyboard = UIStoryboard(name: "Alert", bundle: nil)
        let identifier = String(describing: RemoveAlertViewController.self)
        guard let alertViewController = storyboard.instantiateViewController(withIdentifier: identifier) as? RemoveAlertViewController else { return RemoveAlertViewController()}
        
        alertViewController.text = text
        alertViewController.deleteAction = completion
        return alertViewController
    }
    
}
