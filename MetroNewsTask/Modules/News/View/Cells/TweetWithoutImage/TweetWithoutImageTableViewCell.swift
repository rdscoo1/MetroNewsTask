import UIKit

protocol _TweetWithoutImageTableViewCell {
    var id: Int { get set }
    var text: String { get set }
    var statistics: TweetStatistics.ViewState { get set }
}

class TweetWithoutImageTableViewCell: UITableViewCell {

    static let reuseId = "TweetWithoutImageTableViewCell"
    
    // MARK: - UI

    @IBOutlet private weak var tweetTextLabel: UILabel!
    @IBOutlet private weak var tweetStatistics: TweetStatistics!
    
}

// MARK: - ConfigurableView

extension TweetWithoutImageTableViewCell: ConfigurableView {
    func configure(with model: _TweetWithoutImageTableViewCell) {
        tweetTextLabel.isUserInteractionEnabled = true
        tweetTextLabel.attributedText = Constants.handleUrls(from: model.text)
        tweetStatistics.configure(with: model.statistics)
    }
}
