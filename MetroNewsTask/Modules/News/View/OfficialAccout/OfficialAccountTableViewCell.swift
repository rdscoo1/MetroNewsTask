//
//  OfficialAccountTableViewCell.swift
//  MetroNewsTask
//
//  Created by Roman Khodukin on 25.04.2021.
//

import UIKit

class OfficialAccountTableViewCell: UITableViewCell {

    static let reuseId = "OfficialAccountTableViewCell"
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var metroLogoView: MetroLogoView!
    
    // MARK: - AwakeFromNib
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        containerView.layer.cornerRadius = Constants.Layout.cornerRadius
        containerView.layer.applyShadow(color: .black, alpha: 0.16, x: 0, y: 0, blur: 24, spread: 0)
    }
    
}
