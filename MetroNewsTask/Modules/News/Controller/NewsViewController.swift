import UIKit
import SafariServices

class NewsViewController: UIViewController {
    
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
        return tableView
    }()
    
    // MARK: - Private Properties
    
    private let tableViewDataSourceDelegate = NewsTableViewDataSourceDelegate()
    private let networkManager = NetworkManager()
    
    // MARK: - Public Properties
    
    var props: Props = .loading {
        didSet {
            tableViewDataSourceDelegate.updateProp(with: self.props)
            configureCellSelection(with: self.props)
            tableView.reloadData()
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = Constants.LocalizationKey.news.string
        setupView()
        loadData()
    }
    
    // MARK: - Private Methods
    
    private func configureCellSelection(with props: Props) {
        switch props {
        case .loaded(_):
            tableView.allowsSelection = true
        case .error(_), .loading:
            tableView.allowsSelection = false
        }
    }
    
    private func didSelectTweet(at id: Int) {
        let urlString = Constants.twitterUrl + String(id)
        
        if let url = URL(string: urlString) {
            let sfController = SFSafariViewController(url: url)
            sfController.preferredControlTintColor = Constants.Colors.red
            sfController.delegate = self
            
            present(sfController, animated: true)
        }
    }
    
    private func loadData() {
        props = .loading
        networkManager.makeRequest(request: TweetsRequest()) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.props = .error(Props.Error(action: { self.loadData() }))
                }
                print(error.localizedDescription)
            case .success(let data):
                DispatchQueue.main.async {
                    let propsData = data.map { tweet in
                        return Props.Loaded(
                            id: tweet.id,
                            text: tweet.text,
                            createdAt: tweet.createdAt,
                            retweetCount: tweet.retweetCount,
                            favoriteCount: tweet.favoriteCount,
                            mediaEntities: tweet.mediaEntities,
                            onSelect: { id in
                                self.didSelectTweet(at: id)
                            })
                    }
                    self.props = .loaded(propsData)
                }
            }
        }
    }
    
    private func setupView() {
        view.backgroundColor = Constants.Colors.appTheme
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
}

// MARK: - SFSafariViewControllerDelegate Conformance

extension NewsViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
}
