import UIKit

class NewsTableViewDataSourceDelegate: NSObject, UITableViewDataSource {
    
    // MARK: - Public Properties
    
    var props: NewsViewController.Props = .loading
    var tweets: [Tweet] = []
    var didSelectTweet: (Int) -> Void
    
    // MARK: - Init
    
    init(didSelectTweet: @escaping (Int) -> Void) {
        self.didSelectTweet = didSelectTweet
    }
    
    // MARK: - Public Methods
    
    func getTweetId(cellNumber: Int) -> Int? {
        if case .loaded(let data) = props {
            return data[cellNumber].id
        }
        
        return nil
    }
    
    func updateProp(with props: NewsViewController.Props) {
        self.props = props
    }
    
    // MARK: - DataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if case .loaded(let data) = props {
            return data.count
        } else if case .loading = props{
            return 1
        } else if case .error = props {
            return 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if case .loaded(let data) = props {
            let tweet = data[indexPath.row]
            
            if !tweet.mediaEntities.isEmpty {
                guard let tweetCell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.reuseId, for: indexPath) as? TweetTableViewCell
                else { return UITableViewCell() }
                
                tweetCell.configure(with: tweet)
                
                return tweetCell
            } else {
                guard let tweetWithoutImageCell = tableView.dequeueReusableCell(withIdentifier: TweetWithoutImageTableViewCell.reuseId, for: indexPath) as? TweetWithoutImageTableViewCell
                else { return UITableViewCell() }
                
                tweetWithoutImageCell.configure(with: tweet)
                
                return tweetWithoutImageCell
            }
        } else if case .loading = props {
            let loadingCell = tableView.dequeueReusableCell(withIdentifier: "LoadingTableViewCell", for: indexPath)
                        
            return loadingCell
        } else if case .error(let errorData) = props {
            guard let errorCell = tableView.dequeueReusableCell(withIdentifier: ErrorTableViewCell.reuseId, for: indexPath) as? ErrorTableViewCell
            else { return UITableViewCell() }
            
            errorCell.didTapTryAgain = {                
                errorData.action()
            }
            
            return errorCell
        }
        
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate

extension NewsTableViewDataSourceDelegate: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0

        UIView.animate(withDuration: 0.3, delay: 0, animations: {
            cell.alpha = 1
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if case .loaded = props {
            didSelectTweet(indexPath.row)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if case .loaded = props {
            guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: OfficialAccountHeaderTableView.reuseId)  as? OfficialAccountHeaderTableView else {
                return nil
            }
            view.setupUI()
            
            return view
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if case .loaded = props {
            return 144
        }
        
        return 0
    }
}
