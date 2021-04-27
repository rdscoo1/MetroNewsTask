import UIKit
import SafariServices

class NewsViewController: UIViewController {
    
    // MARK: - Private Properties

    private let networkManager = NetworkManager()

    // MARK: - Life Cycle
    
    override func loadView() {
        view = NewsView(frame: UIScreen.main.bounds)
        view.backgroundColor = Constants.Colors.appTheme
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    // MARK: - Private Methods
    
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
        updateView(with: .loading)
        networkManager.makeRequest(request: TweetsRequest()) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.updateView(with: .error(NewsView.Props.Error(action: { self.loadData() })))
                }
                print(error.localizedDescription)
            case .success(let data):
                DispatchQueue.main.async {
                    let propsData = data.map { tweet in
                        return NewsView.Props.Loaded(
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
                    self.updateView(with: .loaded(propsData))
                }
            }
        }
    }

    // MARK: - Public Methods
    
    func updateView(with props: NewsView.Props) {
        if let customView = view as? NewsView {
            customView.props = props
        }
    }

}

// MARK: - SFSafariViewControllerDelegate Conformance

extension NewsViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
}
