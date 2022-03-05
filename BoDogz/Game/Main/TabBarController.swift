import UIKit

class TabBarController : UITabBarController, UITabBarControllerDelegate {
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        showHint()
        self.selectedIndex = 1
        setupHomeButton()
    }
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @objc private func handleMoveToHome(sender: UIButton) {
        self.selectedIndex = 1
    }
    
    @objc private func showFact() {
        let randomFactViewController = createFactViewController()
                
        NetworkManager.shared.requestFact { fact in
            randomFactViewController.text = fact
            self.present(randomFactViewController, animated: true)
        }
    }
    
    private func setupHomeButton() {
        let homeButtonWidth: CGFloat = 80
        
        let homeButton = UIButton(frame: CGRect(x: (self.view.bounds.width / 2) - (homeButtonWidth / 2), y: -20, width: homeButtonWidth, height: homeButtonWidth))
        homeButton.setBackgroundImage(UIImage(named: "dog"), for: .normal)

        homeButton.layer.shadowColor = UIColor.white.cgColor
        homeButton.layer.cornerRadius = homeButton.frame.width / 2.6
        homeButton.backgroundColor = .clear
        self.tabBar.addSubview(homeButton)
        
        homeButton.addTarget(self, action: #selector(handleMoveToHome), for: .touchUpInside)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(showFact))
        doubleTap.numberOfTapsRequired = 2
        homeButton.addGestureRecognizer(doubleTap)
        
        homeButton.clipsToBounds = true
        self.view.layoutIfNeeded()
    }
    
    private func createFactViewController() -> RandomFactViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = String(describing: RandomFactViewController.self)
        guard let randomFactViewController = storyboard.instantiateViewController(withIdentifier: identifier) as? RandomFactViewController else { return RandomFactViewController() }
        
        randomFactViewController.modalPresentationStyle = .popover
        
        let popOverViewContoller = randomFactViewController.popoverPresentationController
        popOverViewContoller?.delegate = self
        
        popOverViewContoller?.sourceView = self.view
        popOverViewContoller?.sourceRect = CGRect(x: self.view.bounds.midX,
                                                  y: self.view.bounds.maxY - 100,
                                                  width: 0,
                                                  height: 0)
        randomFactViewController.preferredContentSize = CGSize(width: 180, height: 120)
        return randomFactViewController
    }
    
    private func showHint() {
        let deadline = DispatchTime.now() + Double.random(in: 2...5)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            let randomFactViewController = self.createFactViewController()
            randomFactViewController.showFact = false
            self.present(randomFactViewController, animated: true)
        }
    }
}

extension TabBarController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
}
