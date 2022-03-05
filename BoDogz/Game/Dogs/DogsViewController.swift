import UIKit

class DogsViewController: BaseViewController, RemoveCellDelegate {
    
    private var dogs: [SavedDog]?
    
    private var documentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var dogsLabel: UILabel!
    @IBOutlet weak var sadDogImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupCollectionView()
        loadData()
        setupNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.searchButton.layer.cornerRadius = 10
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        tabBarController?.selectedIndex = 0
    }
    
    private func loadData() {
        self.dogs = DataManager.shared.get()
        self.collectionView.reloadData()
    }
    
    private func setupCollectionView() {
        let cellName = String(describing: DogCollectionViewCell.self)
        let cellNib = UINib(nibName: cellName, bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: cellName)
    }
    
    func reloadData(completion: @escaping(() -> Void)) {
        let alert = AlertService.shared.removeAlert(Constants.removeDog) {
            completion()
            self.dogs = DataManager.shared.get()
            self.collectionView.reloadData()
        }
        present(alert, animated: true)
    }
    
    private func placeholder(hide: Bool) {
        self.stackView.isHidden = hide
        self.dogsLabel.isHidden = hide
        self.sadDogImageView.isHidden = hide
        self.searchButton.isHidden = hide
    }
    
    private func setupNavBar() {
        navigationItem.title = "My Dogs"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem?.imageInsets = .init(top: 6, left: 0, bottom: 0, right: 0)
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        let font = UIFont(name: "Copperplate Bold", size: 40) ?? UIFont.systemFont(ofSize: 40)
        
        navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : CustomColors.darkRed, NSAttributedString.Key.font : font]
        
        navBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : CustomColors.darkRed, NSAttributedString.Key.font : font]
        
        navBarAppearance.backgroundColor = CustomColors.darkGray
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        self.navigationController?.navigationBar.setNeedsLayout()
    }
}


extension DogsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = dogs?.count else { return 0 }
        if count > 0 {
            placeholder(hide: true)
        } else {
            placeholder(hide: false)
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = String(describing: DogCollectionViewCell.self)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? DogCollectionViewCell else { return UICollectionViewCell() }
        
        guard let dogs = self.dogs else { return UICollectionViewCell() }
        let object = dogs[indexPath.item]
        
        cell.object = object
        cell.removeDelegate = self
        cell.configure()
        
        return cell
    }
}

extension DogsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.collectionView.frame.width
        let height = self.collectionView.frame.height
        
        return CGSize(width: width, height: height)
    }
}
