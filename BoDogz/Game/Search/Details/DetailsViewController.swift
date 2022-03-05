import UIKit

class DetailsViewController: BaseViewController {
    
    var details: List?
    var additionDelegate: AdditionDelegate?
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dogImageView: UIImageView!
    @IBOutlet weak var lifeSpanLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var temperamentLabel: UILabel!
    @IBOutlet weak var bredForLabel: UILabel!
    @IBOutlet weak var breedGroupLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var topGestureZone: UIView!
    @IBOutlet weak var bottomGestureZone: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDetails()
        setupGesture()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.addButton.layer.cornerRadius = 15
        self.containerView.layer.cornerRadius = 15
        self.dogImageView.layer.cornerRadius = 10
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = String(describing: AdditionViewController.self)
        guard let additionViewController = storyboard.instantiateViewController(withIdentifier: identifier) as? AdditionViewController else { return }
        additionViewController.modalPresentationStyle = .overFullScreen
        additionViewController.defaultImage = dogImageView.image
        additionViewController.defaultBreed = breedLabel.text
        
        dismissAnimated {
            self.additionDelegate?.present(additionViewController)
        }
    }
    
    @objc private func tappedTop() {
        dismissAnimated(completion: nil)
    }
    
    @objc private func tappedBottom() {
        dismissAnimated(completion: nil)
    }
    
    private func dismissAnimated(completion: (()->())?) {
        UIView.animate(withDuration: 0.15) {
            self.view.backgroundColor = .clear
        } completion: { _ in
            self.dismiss(animated: true) {
                guard completion != nil else { return }
                completion!()
            }
        }
    }
    
    
    private func setupDetails() {
        guard let details = details else { return }

        if let dogImageURL  = details.image?.url {
            ImageManager.shared.setImage(for: dogImageView, url: dogImageURL)
        }
    
        if let lifeSpan = details.lifeSpan {
            lifeSpanLabel.text = lifeSpan
        }
        
        if let weight = details.weight?.metric {
            weightLabel.text = weight + "kg"
        }
        
        if let breed  = details.name {
            breedLabel.text = breed
        }
        
        if let temperament = details.temperament {
            temperamentLabel.text = temperament
        }
        
        if let bredFor = details.bredFor {
            bredForLabel.text = bredFor
        }
        
        if let breedGroup = details.breedGroup {
            breedGroupLabel.text = breedGroup
        }
    }
    
    private func setupGesture() {
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
