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
        
        setShadow()
    }
    
    private func setShadow() {
        if #available(iOS 13.0, *) {
            if traitCollection.userInterfaceStyle == .dark {
                containerView.layer.applyShadow(color: .white, alpha: 0.08, x: 0, y: 0, blur: 24, spread: 0)
            } else {
                containerView.layer.applyShadow(color: .black, alpha: 0.16, x: 0, y: 0, blur: 24, spread: 0)
            }
        } else {
            containerView.layer.applyShadow(color: .black, alpha: 0.16, x: 0, y: 0, blur: 24, spread: 0)
        }
    }
    
}

// MARK: - traitCollectionDidChange

extension OfficialAccountTableViewCell {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if #available(iOS 13.0, *) {
            if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                if traitCollection.userInterfaceStyle == .dark {
                    containerView.layer.applyShadow(color: .white, alpha: 0.08, x: 0, y: 0, blur: 24, spread: 0)
                }
                else {
                    containerView.layer.applyShadow(color: .black, alpha: 0.16, x: 0, y: 0, blur: 24, spread: 0)
                }
            }
        } else {
            containerView.layer.applyShadow(color: .black, alpha: 0.16, x: 0, y: 0, blur: 24, spread: 0)
        }
    }
}
