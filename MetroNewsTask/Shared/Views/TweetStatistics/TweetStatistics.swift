import UIKit
import SwiftDate

protocol _TweetStatistics {
    var favoriteCount: Int { get set }
    var retweetCount: Int { get set }
    var createdAt: Int { get set }
}

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
    func configure(with model: _TweetStatistics) {
        favoriteLabel.text = "\(model.favoriteCount)"
        retweetLabel.text = "\(model.retweetCount)"
        
        let dateInRegion = DateInRegion(milliseconds: model.createdAt, region: Constants.regionRus)
        var dateStr: String = ""
        
        if Constants.languageStr == "ru" {
            dateStr = dateInRegion.toRelative(since: DateInRegion(), style: RelativeFormatter.defaultStyle(), locale: Locales.russian)
        } else {
            dateStr = dateInRegion.toRelative(since: DateInRegion(), style: RelativeFormatter.defaultStyle(), locale: Locales.english)
        }
        
        dateLabel.text = dateStr
    }
}

