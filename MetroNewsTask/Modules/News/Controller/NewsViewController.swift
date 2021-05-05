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
            let onSelect: (Int) -> ()
        }
        
        struct TweetLoadedWithoutImage: _TweetWithoutImageTableViewCell {
            var id: Int
            var text: String
            let onSelect: (Int) -> ()
        }
        
        struct Error: _ErrorTableViewCell {
            var didTapTryAgain: (() -> Void)?
        }
        
        static let loading = ViewState(rows: [Loading()])
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
        tableView.register(UINib(nibName: "OfficialAccountTableViewCell", bundle: nil),
                           forCellReuseIdentifier: OfficialAccountTableViewCell.reuseId)
        tableView.separatorStyle = .none
        tableView.backgroundColor = Constants.Colors.appTheme
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    // MARK: - Private Properties
    
    //    private let tableViewDataSourceDelegate = NewsTableViewDataSourceDelegate()
    private let networkManager = NetworkManager()
    
    // MARK: - Public Properties
    
    public var viewState: ViewState = .loading {
        didSet {
            //            tableViewDataSourceDelegate.updateProp(with: self.initial)
            //            configureCellSelection(with: self.props)
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
                    let tweetCell = ViewState.TweetLoaded(id: datum.id,
                                                          text: datum.text,
                                                          imageUrl: datum.mediaEntities[0],
                                                          onSelect: { id in
                                                            self.didSelectTweet(at: id)
                                                          })
                    viewState.rows.append(tweetCell)
                } else {
                    let tweetWithoutImageCell = ViewState.TweetLoadedWithoutImage(
                        id: datum.id,
                        text: datum.text,
                        onSelect: { id in
                            self.didSelectTweet(at: id)
                        })
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
            let data = self.viewState.rows[indexPath.row] as! ViewState.TweetLoaded
            let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.reuseId, for: indexPath) as! TweetTableViewCell
            cell.configure(with: data)
            return cell
        case is ViewState.TweetLoadedWithoutImage:
            let data = self.viewState.rows[indexPath.row] as! ViewState.TweetLoadedWithoutImage
            let cell = tableView.dequeueReusableCell(withIdentifier: TweetWithoutImageTableViewCell.reuseId, for: indexPath) as! TweetWithoutImageTableViewCell
            cell.configure(with: data)
            return cell
        default:
            print("default")
            return UITableViewCell()
        }
    }
    
    //        switch props {
    //        case .loaded(let data):
    //            guard let tweet = data[safe: indexPath.row] else {
    //                return UITableViewCell()
    //            }
    //            if !tweet.mediaEntities.isEmpty {
    //                guard let tweetCell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.reuseId, for: indexPath) as? TweetTableViewCell
    //                else { return UITableViewCell() }
    //
    //                tweetCell.configure(with: tweet)
    //
    //                return tweetCell
    //            } else {
    //                guard let tweetWithoutImageCell = tableView.dequeueReusableCell(withIdentifier: TweetWithoutImageTableViewCell.reuseId, for: indexPath) as? TweetWithoutImageTableViewCell
    //                else { return UITableViewCell() }
    //
    //                tweetWithoutImageCell.configure(with: tweet)
    //
    //                return tweetWithoutImageCell
    //            }
    //        case .error(let errorData):
    //            guard let errorCell = tableView.dequeueReusableCell(withIdentifier: ErrorTableViewCell.reuseId, for: indexPath) as? ErrorTableViewCell
    //            else { return UITableViewCell() }
    //
    //            errorCell.didTapTryAgain = {
    //                errorData.action()
    //            }
    //
    //            return errorCell
    //        case .loading:
    //            let loadingCell = tableView.dequeueReusableCell(withIdentifier: "LoadingTableViewCell", for: indexPath)
    //
    //            return loadingCell
}

// MARK: - UITableViewDelegate

extension NewsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0, animations: {
            cell.alpha = 1
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        if case .loaded(let tweets) = props, let tweet = tweets[safe: indexPath.row]  {
    //            tweet.onSelect(tweet.id)
    //        }
    //        tableView.deselectRow(at: indexPath, animated: true)
    //    }
    //
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        if case .loaded = props {
    //            guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: OfficialAccountHeaderTableView.reuseId)  as? OfficialAccountHeaderTableView else {
    //                return nil
    //            }
    //            view.setupUI()
    //
    //            return view
    //        }
    //
    //        return nil
    //    }
    //
    //    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        if case .loaded = props {
    //            return 144
    //        }
    //
    //        return 0
    //    }
}


// MARK: - SFSafariViewControllerDelegate Conformance

extension NewsViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
}
