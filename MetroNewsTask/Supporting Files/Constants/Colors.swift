import UIKit

extension Constants {
    
    enum Colors {
        
        static let errorIcon = UIColor(hex: "#FF3B30")
        
        static let blue = UIColor(hex: "#1DA1F2")
        
        static let gray = UIColor(hex: "#98999A")
        
        static var appTheme: UIColor {
            if #available(iOS 13.0, *) {
                return UIColor { (traits) -> UIColor in
                    return traits.userInterfaceStyle == .dark ?
                        UIColor(hex: "#27292D") :
                        UIColor.white
                }
            } else {
                return UIColor.white
            }
        }
        
        static var label: UIColor {
            if #available(iOS 13.0, *) {
                return UIColor { (traits) -> UIColor in
                    return traits.userInterfaceStyle == .dark ?
                        UIColor.white :
                        UIColor.black
                }
            } else {
                return UIColor.black
            }
        }
        
        static var red: UIColor {
            if #available(iOS 13.0, *) {
                return UIColor { (traits) -> UIColor in
                    return traits.userInterfaceStyle == .dark ?
                        UIColor(hex: "#F54C54") :
                        UIColor(hex: "#DA2032")
                }
            } else {
                return UIColor(hex: "#DA2032")
            }
        }
        
        static var buttonBackground: UIColor {
            if #available(iOS 13.0, *) {
                return UIColor { (traits) -> UIColor in
                    return traits.userInterfaceStyle == .dark ?
                        UIColor(hex: "#2D2F34") :
                        UIColor(hex: "#FAF0F1")
                }
            } else {
                return UIColor(hex: "#FAF0F1")
            }
        }
        
    }
    
}
