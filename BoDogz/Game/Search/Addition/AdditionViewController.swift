import Photos
import PhotosUI
import UIKit

class AdditionViewController: BaseViewController {
    
    var defaultImage: UIImage?
    var defaultBreed: String?
    
    private var selectedImage: UIImage?
    private var newImageSet: Bool = false
    
    private var documentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dogImageFrameView: UIView!
    @IBOutlet weak var dogImageView: UIImageView!
    @IBOutlet weak var setDefaultPhotoLabel: UILabel!
    @IBOutlet weak var birthDatePicker: UIDatePicker!
    @IBOutlet weak var genderSegmentControl: UISegmentedControl!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var spayedSwitch: UISwitch!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var clearAllButton: UIButton!
    
    @IBOutlet weak var topGestureZone: UIView!
    @IBOutlet weak var bottomGestureZone: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameTextField.delegate = self
        self.bioTextField.delegate = self
        setupDefaults()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setCornerRadiuses()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        if self.nameTextField.text != "" && newImageSet  {
            
            guard let name = self.nameTextField.text else { return }
            guard let image = self.dogImageView.image else { return }
            guard let imagePath =  save(image: image, fileName: name) else { return }
            guard let breed = self.breedLabel.text else { return }
            let bio = self.bioTextField.text
            
            let object = SavedDog()
            object.birthDate = self.birthDatePicker.date
            object.genderSegmentIndex = self.genderSegmentControl
                .selectedSegmentIndex
            object.imagePath = imagePath
            object.name = name
            object.bio = bio ?? "No bio."
            object.breed = breed
            object.spayed = self.spayedSwitch.isOn
            
            if DataManager.shared.save(object: object) {
                let alert = AlertService.shared.alert(Constants.saved)
                alert.savingDelegate = self
                self.present(alert, animated: true)
            } else {
                let alert = AlertService.shared.alert(Constants.dogAlreadySaved)
                self.present(alert, animated: true)
            }
            
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismissWithAnimation()
    }
    
    @IBAction func clearAllButtonPressed(_ sender: UIButton) {
        
        if self.nameTextField.text != "" || self.bioTextField.text != "" || self.newImageSet || self.spayedSwitch.isOn {
            
            
            self.dogImageFrameView.backgroundColor = .systemGray
            self.dogImageView.image = UIImage(named: "camera")
            
            let currentDate = Date()
            self.birthDatePicker.setDate(currentDate, animated: true)
            
            self.genderSegmentControl.selectedSegmentIndex = 0
            
            self.nameTextField.text = ""
            self.bioTextField.text = ""
            
            self.spayedSwitch.isOn = false
            
            self.newImageSet = false
            
            let alert = AlertService.shared.alert(Constants.cleaned)
            present(alert, animated: true)
        }
    }

    @objc private func setDefaultImage() {
        if let defaultImage = defaultImage {
            self.dogImageView.image = defaultImage
            self.dogImageFrameView.backgroundColor = .white
            
            self.newImageSet = true
        }
    }
    
    @objc private func setImage() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        config.filter = .images
        
        let photoPickerViewController = PHPickerViewController(configuration: config)
        photoPickerViewController.delegate = self
        
        present(photoPickerViewController, animated: true)
    }
    
    @objc private func tappedTop()  {
        dismissWithAnimation()
    }
    
    @objc private func tappedBottom()  {
        dismissWithAnimation()
    }
    
    private func dismissWithAnimation() {
        UIView.animate(withDuration: 0.15) {
            self.view.backgroundColor = .clear
        } completion: { _ in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func save(image: UIImage, fileName: String) -> String? {
        let fileName = fileName
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            try? imageData.write(to: fileURL, options: .atomic)
            return fileName
        } else {
            return nil
        }
    }
    
    
    private func setupDefaults() {
        if let breed = self.defaultBreed {
            self.breedLabel.text = breed
        }
        
        self.spayedSwitch.isOn = false
        
        setupGestures()
    }
    
    private func setupGestures() {
        let setDefaultImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(setDefaultImage))
        self.setDefaultPhotoLabel.isUserInteractionEnabled = true
        self.setDefaultPhotoLabel.addGestureRecognizer(setDefaultImageTapGesture)
        
        
        let setImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(setImage))
        self.dogImageView.isUserInteractionEnabled = true
        self.dogImageView.addGestureRecognizer(setImageTapGesture)
        
        let topGesture = UITapGestureRecognizer(target: self, action: #selector(tappedTop))
        topGesture.numberOfTapsRequired = 1
        self.topGestureZone.isUserInteractionEnabled = true
        self.topGestureZone.addGestureRecognizer(topGesture)
        
        let bottomGesture = UITapGestureRecognizer(target: self, action: #selector(tappedBottom))
        bottomGesture.numberOfTapsRequired = 1
        self.bottomGestureZone.isUserInteractionEnabled = true
        self.bottomGestureZone.addGestureRecognizer(bottomGesture)
    }
    
    private func setCornerRadiuses() {
        self.containerView.layer.cornerRadius = 20
        
        self.dogImageFrameView.layer.cornerRadius = dogImageFrameView.frame.width / 2
        self.dogImageView.layer.cornerRadius = dogImageView.frame.width / 2
        
        let buttonCornerRadius: CGFloat = 10
        self.saveButton.layer.cornerRadius = buttonCornerRadius
        self.cancelButton.layer.cornerRadius = buttonCornerRadius
        self.clearAllButton.layer.cornerRadius = buttonCornerRadius
    }
}

extension AdditionViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        let group = DispatchGroup()
        
        results.forEach { result in
            group.enter()
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                
                defer {
                    group.leave()
                }
                
                guard let image = reading as? UIImage, error == nil else { return }
                self.selectedImage = image
            }
        }
        
        group.notify(queue: .main) {
            guard self.selectedImage != nil else { return }
            self.dogImageView.image = self.selectedImage
            self.dogImageFrameView.backgroundColor = .white
            self.newImageSet = true
        }
        
    }
}

extension AdditionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension AdditionViewController: SavingDelegate {
    func dismiss() {
        self.view.backgroundColor = .black.withAlphaComponent(0)
        self.dismiss(animated: true, completion: nil)
    }
}
