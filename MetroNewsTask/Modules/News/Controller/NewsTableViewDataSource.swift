import UIKit

class NewsTableViewDataSource: NSObject, UITableViewDataSource {
    
    // MARK: - DataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                guard let errorCell = tableView.dequeueReusableCell(withIdentifier: ErrorTableViewCell.reuseId, for: indexPath) as? ErrorTableViewCell
                else { return UITableViewCell() }

                return errorCell
        
//                let loadingCell = tableView.dequeueReusableCell(withIdentifier: "LoadingTableViewCell", for: indexPath)
//
//                return loadingCell
        
//        guard let officialAccountCell = tableView.dequeueReusableCell(withIdentifier: OfficialAccountTableViewCell.reuseId, for: indexPath) as? OfficialAccountTableViewCell
//        else { return UITableViewCell() }
//
//        return officialAccountCell
        
//        guard let tweetCell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.reuseId, for: indexPath) as? TweetTableViewCell
//        else { return UITableViewCell() }
//
//        return tweetCell
//
//        guard let tweetWithoutImageCell = tableView.dequeueReusableCell(withIdentifier: TweetWithoutImageTableViewCell.reuseId, for: indexPath) as? TweetWithoutImageTableViewCell
//        else { return UITableViewCell() }
//
//        return tweetWithoutImageCell
        
        
    }
}
