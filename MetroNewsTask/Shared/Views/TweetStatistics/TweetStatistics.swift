import UIKit
import SwiftDate

class TweetStatistics: UIView {
    
    @IBOutlet private weak var retweetLabel: UILabel!
    @IBOutlet private weak var favoriteLabel: UILabel!
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
        favoriteLabel.text = "\(model.favoriteCount)"
        retweetLabel.text = "\(model.retweetCount)"
        
        let dateInRegion = DateInRegion(milliseconds: model.createdAt, region: Constants.region)
        let dateStr = dateInRegion.toRelative(since: DateInRegion(), style: RelativeFormatter.defaultStyle(), locale: Locales.russian)
        
        dateLabel.text = dateStr
    }
}

