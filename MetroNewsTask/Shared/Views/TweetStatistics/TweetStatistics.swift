import UIKit
import SwiftDate

class TweetStatistics: UIView {
    
    @IBOutlet private weak var favoriteCountLabel: UILabel!
    @IBOutlet private weak var retweetCountLabel: UILabel!
    @IBOutlet private weak var chatCountLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
}

extension TweetStatistics: ConfigurableView {
    func configure(with model: Tweet) {
        favoriteCountLabel.text = "\(model.favoriteCount)"
        retweetCountLabel.text = "\(model.retweetCount)"
        let regionMS = Region(calendar: Calendars.gregorian, zone: Zones.europeMoscow, locale: Locales.russianRussia)

        dateLabel.text = DateInRegion(milliseconds: model.createdAt, region: regionMS).toString()
    }
}

