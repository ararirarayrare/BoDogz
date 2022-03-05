import UIKit

class DogCollectionViewCell: UICollectionViewCell {
    
    var removeDelegate: RemoveCellDelegate?
    var object: SavedDog?
    
    private var documentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    @IBOutlet weak var dogName: UILabel!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var removeImageView: UIImageView!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var spayelLabel: UILabel!
    @IBOutlet weak var birthDateAndAgeLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupGesture()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setCornerRadiuses()
    }
    
    @objc private func remove() {
        guard let object = object else { return }
        removeDelegate?.reloadData(completion: {
            DataManager.shared.deleteSelected(object: object)
        })
    }
    
    private func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(remove))
        removeImageView.isUserInteractionEnabled = true
        removeImageView.addGestureRecognizer(tap)
    }
    
    private func setCornerRadiuses() {
        self.imageContainerView.layer.cornerRadius = self.imageContainerView.frame.width / 2
        self.imageView.layer.cornerRadius = self.imageView.frame.width / 2
    }
    

    func configure() {
        guard let info = object else { return }

        self.dogName.text = info.name
        
        let imagePath = info.imagePath
        if let image = load(fileName: imagePath) {
            self.imageView.image = image
        }
        
        self.breedLabel.text = info.breed
        
        if info.genderSegmentIndex == 0 {
            self.genderLabel.text = "Male"
        } else {
            self.genderLabel.text = "Female"
        }
        
        var status = ""
        if info.spayed {
            self.spayelLabel.textColor = CustomColors.darkRed
            if info.genderSegmentIndex == 0 {
                status = "Spayed"
            } else {
                status = "Sterilized"
            }
        } else {
            self.spayelLabel.textColor = CustomColors.darkGreen
            if info.genderSegmentIndex == 0 {
                status = "Not spayed"
            } else {
                status = "Not sterilized"
            }
        }
        self.spayelLabel.text = status
                
        let calendar = Calendar.current
        let formatter = DateFormatter()
        
        let firstDate = info.birthDate
        let secondDate = Date()

        let date1 = calendar.startOfDay(for: firstDate)
        let date2 = calendar.startOfDay(for: secondDate)

        let components = calendar.dateComponents([.year], from: date1, to: date2)
        
        guard let age = components.year else { return }
        
        formatter.dateFormat = "MM-dd-yyyy"
        
        let birtDate = formatter.string(from: firstDate).replacingOccurrences(of: "-", with: "/")
        
        self.birthDateAndAgeLabel.text = "Born: \(birtDate)\nAge: \(age)"
        self.bioLabel.text = info.bio
    }
    
    private func load(fileName: String) -> UIImage? {
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            return nil
        }
    }
}
