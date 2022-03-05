import UIKit

class ReminderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func configureWith(name: String, description: String, date: String) {
        self.nameLabel.text = name
        self.descriptionLabel.text = description
        self.dateLabel.text = date
    }
}
