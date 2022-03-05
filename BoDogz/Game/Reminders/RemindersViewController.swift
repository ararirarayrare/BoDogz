import UIKit

class RemindersViewController: BaseViewController {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var pendingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        extendedLayoutIncludesOpaqueBars = true
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupNavBar()
        setupLargeTitle()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setCornerRadiuses()
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        let dogs = DataManager.shared.get()
        
        if dogs.count > 0  {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let identifier = String(describing: CreateReminderViewController.self)
            guard let createReminderViewController = storyboard.instantiateViewController(withIdentifier: identifier) as? CreateReminderViewController else { return }
            
            present(createReminderViewController, animated: true) {
                UIView.animate(withDuration: 0.15) {
                    createReminderViewController.view.backgroundColor = .black.withAlphaComponent(0.5)
                }
            }
        } else {
            let alert = AlertService.shared.alert(Constants.remindersUnable)
            present(alert, animated: true)
        }
    }
    
    @IBAction func pendingButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = String(describing: PendingRemindersViewController.self)
        guard let pendingRemindersViewController = storyboard.instantiateViewController(withIdentifier: identifier) as? PendingRemindersViewController else { return }
        
        self.present(pendingRemindersViewController, animated: true)
    }
    
    
    private func setCornerRadiuses() {
        self.addButton.layer.cornerRadius = 10
        self.pendingButton.layer.cornerRadius = 10
    }
    
    private func setupNavBar() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        let font = UIFont(name: "Copperplate Bold", size: 40) ?? UIFont.systemFont(ofSize: 40)

        navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : CustomColors.darkRed, NSAttributedString.Key.font : font]
        
        navBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : CustomColors.darkRed, NSAttributedString.Key.font : font]
        
        navBarAppearance.backgroundColor = CustomColors.darkGray
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }

    private func setupLargeTitle() {
        view.backgroundColor = .systemGray2
        navigationItem.title = "Reminders"
    }
}


