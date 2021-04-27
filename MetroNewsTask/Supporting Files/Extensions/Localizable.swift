import Foundation

protocol Localizable {
    var localized: String { get }
}

extension String: Localizable {
    
    /// Returns a localized string pulled from `Localizable.strings` by its key.
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }
}
