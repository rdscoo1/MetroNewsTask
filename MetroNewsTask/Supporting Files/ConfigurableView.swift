import UIKit

protocol ConfigurableView where Self: UIView {
    associatedtype ConfigurationModel

    func configure(with model: ConfigurationModel)
}
