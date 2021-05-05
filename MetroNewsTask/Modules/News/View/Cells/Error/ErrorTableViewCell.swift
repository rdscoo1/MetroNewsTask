import UIKit

protocol _ErrorTableViewCell {
    var didTapTryAgain: (() -> Void)? { get set }
}

class ErrorTableViewCell: UITableViewCell {

    static let reuseId = "ErrorTableViewCell"
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var errorImageView: UIImageView!
    @IBOutlet private weak var errorTitleLabel: UILabel!
    @IBOutlet private weak var errorReasonLabel: UILabel!
    @IBOutlet private weak var tryAgainButton: MetroButton!
    
    // MARK: - Public Properties
    
    private var didTapTryAgain: (() -> Void)?
    
    // MARK: - IBAction
    
    @IBAction func didTapTryAgainButton(_ sender: Any) {
        didTapTryAgain?()
    }
}

extension ErrorTableViewCell: ConfigurableView {
    func configure(with model: _ErrorTableViewCell) {
        didTapTryAgain = model.didTapTryAgain
    }
}
