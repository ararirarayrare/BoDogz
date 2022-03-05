import Foundation
import SDWebImage

struct ImageManager {
    
    static let shared = ImageManager()
    
    func setImage(for imageView: UIImageView, url: String) {
        guard let url = URL(string: url) else { return }
        imageView.sd_setImage(with: url, completed: nil)
    }
}
