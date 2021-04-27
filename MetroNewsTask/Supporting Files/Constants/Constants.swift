import UIKit
import SwiftDate

struct Constants {
    
    static let baseUrl = "devapp.mosmetro.ru" // https://devapp.mosmetro.ru/api/tweets/v1.0/
    static let twitterUrl = "https://twitter.com/MetroOperativno/status/" // https://twitter.com/MetroOperativno/status/123456789
    
    static let languageStr = String(Locale.preferredLanguages[0].prefix(2))
    
    static let regionRus = Region(calendar: Calendars.gregorian, zone: Zones.europeMoscow, locale: Locales.russianRussia)
    static let regionEng = Region(calendar: Calendars.gregorian, zone: Zones.europeMoscow, locale: Locales.english)
    
    static func handleUrls(from string: String) -> NSMutableAttributedString {
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
