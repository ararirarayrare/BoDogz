import UIKit

class CustomNavigationController: BaseNavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        extendedLayoutIncludesOpaqueBars = true
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        setupNavBar()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
    }

    private func setupNavBar() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        let font = UIFont(name: "Copperplate Bold", size: 40) ?? UIFont.systemFont(ofSize: 40)

        navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font : font]
        
        navBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font : font]
        
        navBarAppearance.backgroundColor = CustomColors.darkGreen
        navigationBar.standardAppearance = navBarAppearance
        navigationBar.scrollEdgeAppearance = navBarAppearance
    }
}
