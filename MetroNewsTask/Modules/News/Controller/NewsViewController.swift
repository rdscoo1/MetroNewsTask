import UIKit
import SafariServices

class NewsViewController: UIViewController {
    
    enum StateMode {
        case loading
        case loaded
        case error
    }
    
    struct ViewState {
        
        var rows: [Any]
        
        struct Loading: _LoadingTableViewCell {
            var text: String?
        }
        
        struct OfficialAccountCell { }
        
        struct TweetLoaded: _TweetTableViewCell {
            var id: Int
            var text: String
            var imageUrl: String
            var statistics: TweetStatistics.ViewState
        }
        
        struct TweetLoadedWithoutImage: _TweetWithoutImageTableViewCell {
            var id: Int
            var text: String
            var statistics: TweetStatistics.ViewState
        }
        
        struct Error: _ErrorTableViewCell {
            var didTapTryAgain: (() -> Void)?
        }
        
        static let loading = ViewState(rows: [Loading()])
    }
    
    // MARK: - UI
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UINib(nibName: "ErrorTableViewCell", bundle: nil),
                           forCellReuseIdentifier: ErrorTableViewCell.reuseId)
        tableView.register(UINib(nibName: "LoadingTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "LoadingTableViewCell")
        tableView.register(UINib(nibName: "TweetTableViewCell", bundle: nil),
                           forCellReuseIdentifier: TweetTableViewCell.reuseId)
        tableView.register(UINib(nibName: "TweetWithoutImageTableViewCell", bundle: nil),
                           forCellReuseIdentifier: TweetWithoutImageTableViewCell.reuseId)
        tableView.register(UINib(nibName: "OfficialAccountTableViewCell", bundle: nil),
                           forCellReuseIdentifier: OfficialAccountTableViewCell.reuseId)
        tableView.separatorStyle = .none
        tableView.backgroundColor = Constants.Colors.appTheme
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    // MARK: - Private Properties
    
    private let networkManager = NetworkManager()
    
    // MARK: - Public Properties
    
    public var viewState: ViewState = .loading {
        didSet {
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
    
    private func configureCellSelection(with state: StateMode) {
        switch state {
        case .loaded:
            tableView.allowsSelection = true
        case .error, .loading:
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
    
    private func makeState(with mode: StateMode, data: Any?) {
        configureCellSelection(with: mode)
        switch mode {
        case .loading:
            let loadingCell = ViewState.Loading()
            viewState.rows = [loadingCell]
        case .loaded:
            guard let data = data as? [Tweet] else {
                return
            }
            viewState.rows = []
            
            let officialCell = ViewState.OfficialAccountCell()
            viewState.rows.append(officialCell)
            
            for datum in data {
                if !datum.mediaEntities.isEmpty {
                    let tweetCell = ViewState.TweetLoaded(
                        id: datum.id,
                        text: datum.text,
                        imageUrl: datum.mediaEntities[0],
                        statistics: .init(favoriteCount: datum.favoriteCount,
                                          retweetCount: datum.retweetCount,
                                          createdAt: datum.createdAt))
                    
                    viewState.rows.append(tweetCell)
                } else {
                    let tweetWithoutImageCell = ViewState.TweetLoadedWithoutImage(
                        id: datum.id,
                        text: datum.text,
                        statistics: .init(favoriteCount: datum.favoriteCount,
                                          retweetCount: datum.retweetCount,
                                          createdAt: datum.createdAt))
                    
                    viewState.rows.append(tweetWithoutImageCell)
                }
            }
        case .error:
            let errorCell = ViewState.Error(didTapTryAgain: {
                self.loadData()
            })
            viewState.rows = [errorCell]
        }
    }
    
    private func loadData() {
        makeState(with: .loading, data: nil)
        networkManager.makeRequest(request: TweetsRequest()) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.makeState(with: .error, data: nil)
                }
                print(error.localizedDescription)
            case .success(let data):
                DispatchQueue.main.async {
                    self.makeState(with: .loaded, data: data)
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


// MARK: - UITableViewDataSource

extension NewsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewState.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewState.rows[indexPath.row] {
        case is ViewState.Loading:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingTableViewCell", for: indexPath)
            return cell
        case is ViewState.Error:
            let data = viewState.rows[indexPath.row] as! ViewState.Error
            let cell = tableView.dequeueReusableCell(withIdentifier: ErrorTableViewCell.reuseId, for: indexPath) as! ErrorTableViewCell
            cell.configure(with: data)
            return cell
        case is ViewState.OfficialAccountCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: OfficialAccountTableViewCell.reuseId, for: indexPath) as! OfficialAccountTableViewCell
            return cell
        case is ViewState.TweetLoaded:
            let data = viewState.rows[indexPath.row] as! ViewState.TweetLoaded
            let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.reuseId, for: indexPath) as! TweetTableViewCell
            cell.configure(with: data)
            return cell
        case is ViewState.TweetLoadedWithoutImage:
            let data = viewState.rows[indexPath.row] as! ViewState.TweetLoadedWithoutImage
            let cell = tableView.dequeueReusableCell(withIdentifier: TweetWithoutImageTableViewCell.reuseId, for: indexPath) as! TweetWithoutImageTableViewCell
            cell.configure(with: data)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
}

// MARK: - UITableViewDelegate

extension NewsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0, animations: {
            cell.alpha = 1
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewState.rows[indexPath.row] {
        case is ViewState.TweetLoaded:
            let data = viewState.rows[indexPath.row] as! ViewState.TweetLoaded
            didSelectTweet(at: data.id)
        case is ViewState.TweetLoadedWithoutImage:
            let data = viewState.rows[indexPath.row] as! ViewState.TweetLoadedWithoutImage
            didSelectTweet(at: data.id)
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: - SFSafariViewControllerDelegate Conformance

extension NewsViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
}
