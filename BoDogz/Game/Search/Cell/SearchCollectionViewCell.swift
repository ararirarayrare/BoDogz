import UIKit

class SearchCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var dogImageView: UIImageView!
    @IBOutlet weak var breedLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 10
        self.dogImageView.layer.cornerRadius = 10
    }
    
    func configure(with info: List) {
        guard let name = info.name else { return }
        guard let imageUrl = info.image?.url else { return }
        
        ImageManager.shared.setImage(for: self.dogImageView, url: imageUrl)
        self.breedLabel.text = name
    }
}
