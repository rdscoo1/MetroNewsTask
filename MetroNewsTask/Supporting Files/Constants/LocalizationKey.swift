//
//  LocalizationKey.swift
//  MetroNewsTask
//
//  Created by Roman Khodukin on 27.04.2021.
//

import Foundation

extension Constants {
    enum LocalizationKey: String {
        
        // Titles
        case news = "News"
        
        var string: String {
            return rawValue.localized
        }
    }
}
