import UIKit

class TweetTableViewCell: UITableViewCell {

    static let reuseId = "TweetTableViewCell"
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tweetImageView: UIImageView!
    
    // MARK: - AwakeFromNib
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    private func setupUI() {
        tweetImageView.layer.cornerRadius = Constants.Layout.cornerRadius
    }
}
