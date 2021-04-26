import UIKit

class TweetWithoutImageTableViewCell: UITableViewCell {

    static let reuseId = "TweetWithoutImageTableViewCell"
    
    // MARK: - UI

    @IBOutlet private weak var tweetTextLabel: UILabel!
    @IBOutlet private weak var tweetStatistics: TweetStatistics!
    
}

// MARK: - ConfigurableView

extension TweetWithoutImageTableViewCell: ConfigurableView {
    func configure(with model: Tweet) {
        tweetTextLabel.text = model.text
        tweetStatistics.configure(with: model)
    }
}
