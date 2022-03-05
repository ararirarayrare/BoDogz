import UIKit

class SearchViewController: BaseViewController {
    
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        extendedLayoutIncludesOpaqueBars = true
        setupNavBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchButton.layer.cornerRadius = 15
    }
    
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        let identifier = String(describing: SearchPopoverViewController.self)
        guard let popoverViewController = storyboard?.instantiateViewController(withIdentifier: identifier) as? SearchPopoverViewController else { return }
        popoverViewController.modalPresentationStyle = .overFullScreen
        present(popoverViewController, animated: true)
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Find you'r dog"
        self.view.backgroundColor = .systemGray2
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        
        let font = UIFont(name: "Copperplate Bold", size: 40) ?? UIFont.systemFont(ofSize: 40)
        
        navBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : CustomColors.darkRed, NSAttributedString.Key.font : font]
        navBarAppearance.backgroundColor = CustomColors.darkGray
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
}
