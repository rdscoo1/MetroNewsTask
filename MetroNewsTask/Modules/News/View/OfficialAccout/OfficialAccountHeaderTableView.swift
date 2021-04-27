import UIKit

class OfficialAccountHeaderTableView: UITableViewHeaderFooterView {

    static let reuseId = "OfficialAccountHeaderTableView"
    
    // MARK: - UI
    
    @IBOutlet private weak var containerView: UIView!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.backgroundView = UIView()
        self.backgroundView!.backgroundColor = UIColor.clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundView = UIView()
        self.backgroundView!.backgroundColor = UIColor.clear
    }
    
    // MARK: - Private Methods
    
    func setupUI() {
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

extension OfficialAccountHeaderTableView {
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
