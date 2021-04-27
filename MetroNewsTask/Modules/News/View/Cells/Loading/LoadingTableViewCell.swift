//
//  LoadingTableViewCell.swift
//  MetroNewsTask
//
//  Created by Roman Khodukin on 27.04.2021.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        activityIndicator.startAnimating()
    }
    
}
