import UIKit

class ErrorTableViewCell: UITableViewCell {

    static let reuseId = "ErrorTableViewCell"
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var errorImageView: UIImageView!
    @IBOutlet private weak var errorTitleLabel: UILabel!
    @IBOutlet private weak var errorReasonLabel: UILabel!
    @IBOutlet private weak var tryAgainButton: MetroButton!
    
    // MARK: - IBAction
    
    @IBAction func didTapTryAgainButton(_ sender: Any) {
        print("Trying again")
    }
}
