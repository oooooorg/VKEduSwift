import UIKit

class WelcomeViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var statusLabel: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        statusLabel.text = Constants.ConstantsList.statusLabelTextReady
        activityIndicator.hidesWhenStopped = true
    }
    
    // MARK: - Helper methods
    private func downloadCat() {
        guard let url = URL(string: "https://cataas.com/cat") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.catImageView.image = UIImage(data: data)
                self?.statusLabel.text = Constants.ConstantsList.statusLabelTextEnd
                self?.activityIndicator.stopAnimating()
            }
        }
        
        task.resume()
    }
    
    // MARK: - Actions
    @IBAction func didTapButton(_ sender: Any) {
        activityIndicator.startAnimating()
        statusLabel.text = Constants.ConstantsList.statusLabelTextStart
        downloadCat()
    }
}
