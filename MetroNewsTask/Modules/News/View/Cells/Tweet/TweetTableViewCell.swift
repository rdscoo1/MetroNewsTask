import UIKit
import SDWebImage

protocol _TweetTableViewCell {
    var id: Int { get set }
    var text: String { get set }
    var imageUrl: String { get set }
}

class TweetTableViewCell: UITableViewCell {
    
    static let reuseId = "TweetTableViewCell"
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet private weak var tweetImageView: UIImageView!
    @IBOutlet weak var tweetStatistics: TweetStatistics!
    
    // MARK: - AwakeFromNib
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    private func setupUI() {
        tweetImageView.layer.cornerRadius = Constants.Layout.cornerRadius
    }
}

// MARK: - ConfigurableView

extension TweetTableViewCell: ConfigurableView {
    func configure(with model: _TweetTableViewCell) {
        tweetTextLabel.isUserInteractionEnabled = true
        tweetTextLabel.attributedText = Constants.handleUrls(from: model.text)
        tweetImageView.sd_setImage(with: URL(string: model.imageUrl))
//        tweetStatistics.configure(with: model.statistics)
    }
}
