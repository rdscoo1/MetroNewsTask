import UIKit

protocol _LoadingTableViewCell {
    var text: String? { get set }
}

class LoadingTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        activityIndicator.startAnimating()
    }
    
}

extension LoadingTableViewCell: ConfigurableView {
    func configure(with model: _LoadingTableViewCell) {
        if let text = model.text {
            loadingLabel.text = text
        }
    }
}
