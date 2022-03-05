import UIKit

class SearchPopoverViewController: BaseViewController {
    
    private var list: [List] = [List]()
    private var filteredList:[List] = [List]()
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var sadDogImageView: UIImageView!
    @IBOutlet weak var noInformationLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkInternetConnection()
        configureCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.layer.cornerRadius = 20
        backButton.layer.cornerRadius = 5
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    private func configureCollectionView() {
        let cellName = String(describing: SearchCollectionViewCell.self)
        let cellNib = UINib(nibName: cellName, bundle: nil)
        
        collectionView.register(cellNib, forCellWithReuseIdentifier: cellName)
    }
    
    private func infoIs(loaded: Bool) {
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
        
        self.sadDogImageView.isHidden = loaded
        self.noInformationLabel.text = Constants.noInternet
        self.noInformationLabel.isHidden = loaded
    }
    
    private func checkInternetConnection() {
        if !(NetworkManager.isConnectedToInternet) {
            infoIs(loaded: false)
        } else {
            getData()
        }
    }
    
    private func getData() {
        if self.list.isEmpty {
            NetworkManager.shared.requestListOfBreeds { list in
                self.filteredList = list
                self.list = list
                if !(self.list.isEmpty) {
                    self.infoIs(loaded: true)
                }
                self.collectionView.reloadData()
            }
        }
    }
    
    private func presentAnimated(_ vc: UIViewController) {
        present(vc, animated: true) {
            UIView.animate(withDuration: 0.15) {
                vc.view.backgroundColor = .black.withAlphaComponent(0.6)
            }
        }
    }
}


extension SearchPopoverViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredList.removeAll()
        
        if searchText == "" {
            filteredList = list
        }
        
        for item in list {
            guard let name = item.name else { return }
            if name.uppercased().contains(searchText.uppercased()) {
                filteredList.append(item)
            }
        }
        
        self.collectionView.reloadData()
    }
}


extension SearchPopoverViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filteredList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = String(describing: SearchCollectionViewCell.self)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? SearchCollectionViewCell else { return UICollectionViewCell()}
        let info = self.filteredList[indexPath.item]
        cell.configure(with: info)
        return cell
    }
}


extension SearchPopoverViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let identifier = String(describing: DetailsViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let detailsViewController = storyboard.instantiateViewController(withIdentifier: identifier) as? DetailsViewController else { return }
        
        detailsViewController.details = filteredList[indexPath.item]
        
        detailsViewController.additionDelegate = self
        
        detailsViewController.modalPresentationStyle = .overFullScreen
        presentAnimated(detailsViewController)
    }
}


extension SearchPopoverViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (self.collectionView.frame.width - 24) / 2
        let height = width * 0.85
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
}

extension SearchPopoverViewController: AdditionDelegate {
    func present(_ additionViewController: AdditionViewController) {
        presentAnimated(additionViewController)
    } 
}
