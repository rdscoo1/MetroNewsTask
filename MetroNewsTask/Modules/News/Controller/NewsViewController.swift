import UIKit
import SafariServices

class NewsViewController: UIViewController {
    
    enum Props {
        case loading
        case loaded([Tweet])
        case error(Error)
        
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
    
    // MARK: - Public Properties
    
    var props: Props = .loading {
        didSet {
            tableViewDataSourceDelegate.updateProp(with: self.props)
            configureCellSelection(with: self.props)
            tableView.reloadData()
        }
    }
    
    // MARK: - Private Properties
    
    private lazy var tableViewDataSourceDelegate = NewsTableViewDataSourceDelegate(didSelectTweet: { [weak self] number in
        self?.didSelectTweet(at: number)
    })
    private let networkManager = NetworkManager()

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    private func didSelectTweet(at number: Int) {
        guard let tweetId = tableViewDataSourceDelegate.getTweetId(cellNumber: number) else {
            return
        }
        
        let urlString = Constants.twitterUrl + String(tweetId)
        
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
            case .success(let items):
                DispatchQueue.main.async {
                    self.props = .loaded(items)
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
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
