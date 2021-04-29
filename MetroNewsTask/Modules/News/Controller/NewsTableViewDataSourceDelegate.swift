import UIKit

class NewsTableViewDataSourceDelegate: NSObject {
    
    // MARK: - Public Properties
    
    var props: NewsViewController.Props = .loading
    
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
    
}

// MARK: - UITableViewDataSource

extension NewsTableViewDataSourceDelegate: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch props {
        case .loaded(let data):
            return data.count
        case .loading, .error:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch props {
        case .loaded(let data):
            guard let tweet = data[safe: indexPath.row] else {
                return UITableViewCell()
            }
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
        case .error(let errorData):
            guard let errorCell = tableView.dequeueReusableCell(withIdentifier: ErrorTableViewCell.reuseId, for: indexPath) as? ErrorTableViewCell
            else { return UITableViewCell() }
            
            errorCell.didTapTryAgain = {
                errorData.action()
            }
            
            return errorCell
        case .loading:
            let loadingCell = tableView.dequeueReusableCell(withIdentifier: "LoadingTableViewCell", for: indexPath)
            
            return loadingCell
        }
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
        if case .loaded(let tweets) = props, let tweet = tweets[safe: indexPath.row]  {
            tweet.onSelect(tweet.id)
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
