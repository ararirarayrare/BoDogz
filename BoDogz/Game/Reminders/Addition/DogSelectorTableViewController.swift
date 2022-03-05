import UIKit

class DogSelectorTableViewController: UITableViewController {
    
    var selectionDelegate: SelectDogDelegate?
    
    var names: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.names =  DataManager.shared.getNames()
        tableView.isScrollEnabled = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        preferredContentSize = CGSize(width: tableView.contentSize.width, height: tableView.contentSize.height)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.names =  DataManager.shared.getNames()
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let names = names else { return 0 }
        return names.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        guard let names = names else { return UITableViewCell() }
        
        let name = names[indexPath.item]
        let breed = DataManager.shared.getBreedBy(name: name)
        
        var config = UIListContentConfiguration.cell()
        config.text = name
        config.secondaryText = breed
        
        cell.contentConfiguration = config

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let names = self.names else { return }
        let name = names[indexPath.item]
        self.selectionDelegate?.set(name: name)
        self.dismiss(animated: true)
    }
}
