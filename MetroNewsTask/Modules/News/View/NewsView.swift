import UIKit

class NewsView: UIView {
    
    enum Props {
        case loading
        case loaded([Loaded])
        case error(Error)
        
        struct Loaded {
            let id: Int
            let text: String
            let createdAt: Int
            let retweetCount: Int
            let favoriteCount: Int
            let mediaEntities: [String]
            let onSelect: (Int) -> ()
        }
        
        struct Error {
            let action: () -> ()
        }
    }
    
    // MARK: - UI
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UINib(nibName: "ErrorTableViewCell", bundle: nil),
                           forCellReuseIdentifier: ErrorTableViewCell.reuseId)
        tableView.register(UINib(nibName: "LoadingTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "LoadingTableViewCell")
        tableView.register(UINib(nibName: "TweetTableViewCell", bundle: nil),
                           forCellReuseIdentifier: TweetTableViewCell.reuseId)
        tableView.register(UINib(nibName: "TweetWithoutImageTableViewCell", bundle: nil),
                           forCellReuseIdentifier: TweetWithoutImageTableViewCell.reuseId)
        tableView.register(UINib(nibName: "OfficialAccountHeaderTableView", bundle: nil),
                           forHeaderFooterViewReuseIdentifier: OfficialAccountHeaderTableView.reuseId)
        tableView.separatorStyle = .none
        tableView.backgroundColor = Constants.Colors.appTheme
        tableView.dataSource = tableViewDataSourceDelegate
        tableView.delegate = tableViewDataSourceDelegate
        addSubview(tableView)
        tableView.frame = frame
        return tableView
    }()
    
    
    // MARK: - Public Properties
    
    var props: Props = .loading {
        didSet {
            tableViewDataSourceDelegate.updateProp(with: self.props)
            configureCellSelection(with: self.props)
            tableView.reloadData()
        }
    }
    
    // MARK: - Private Properties
    
    private let tableViewDataSourceDelegate = NewsTableViewDataSourceDelegate()
    
    // MARK: - Private Methods
    
    private func configureCellSelection(with props: Props) {
        switch props {
        case .loaded(_):
            tableView.allowsSelection = true
        case .error(_), .loading:
            tableView.allowsSelection = false
        }
    }

}
