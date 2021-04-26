import UIKit
import SDWebImage

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
    func configure(with model: Tweet) {
        
        tweetTextLabel.isUserInteractionEnabled = true
        tweetTextLabel.attributedText = handleUrls(from: model.text)
        tweetImageView.sd_setImage(with: URL(string: model.mediaEntities[0]))
        tweetStatistics.configure(with: model)
    }
    
    private func handleUrls(from string: String) -> NSMutableAttributedString {
        let fullAttributedString = NSMutableAttributedString()
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count))
        
        if !matches.isEmpty {
            var plainAttributedString = NSMutableAttributedString()
            var attributedLinkStringArray: [NSMutableAttributedString] = []
            var urls: [String] = []
            var parsed: String = string
            
            for match in matches {
                guard let range = Range(match.range, in: string) else { continue }
                let url = string[range]
                attributedLinkStringArray.append(
                    NSMutableAttributedString(string: String(url),
                                              attributes:[
                                                NSAttributedString.Key.link: URL(string: String(url))!,
                                                NSAttributedString.Key.foregroundColor: Constants.Colors.blue]))
                urls.append(String(url))
            }
            
            for url in  urls {
                parsed = parsed.replacingOccurrences(of: url, with: "")
            }
            
            plainAttributedString = NSMutableAttributedString(string: parsed, attributes: nil)
            
            fullAttributedString.append(plainAttributedString)
            
            for attrString in attributedLinkStringArray {
                fullAttributedString.append(attrString)
                fullAttributedString.append(NSAttributedString(string: " "))
            }
            
            return fullAttributedString
            
        } else {
            fullAttributedString.append(NSMutableAttributedString(string: string, attributes: nil))
            return fullAttributedString
        }
    }
}
