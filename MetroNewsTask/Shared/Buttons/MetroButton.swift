import UIKit

class MetroButton: UIButton {

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupButton()
    }
    
    init(title: String) {
        super.init(frame: .zero)
        
        setupButton()
        setTitle(title, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    private func setupButton() {
        layer.cornerRadius = Constants.Layout.cornerRadius
        layer.masksToBounds = true
        backgroundColor = Constants.Colors.buttonBackground
        setTitleColor(Constants.Colors.red, for: .normal)
    }
}
