//
//  Colors.swift
//  MetroNewsTask
//
//  Created by Roman Khodukin on 25.04.2021.
//

import UIKit

extension Constants {
    
    enum Colors {
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
        
        static let blue = UIColor(hex: "#1DA1F2")
        
        static let gray = UIColor(hex: "#98999A")
        
    }
    
}
