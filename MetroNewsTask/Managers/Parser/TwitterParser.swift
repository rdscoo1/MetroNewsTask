import SwiftyJSON

class TwitterParser {
    
    static let instance = TwitterParser()
    
    private init(){}
    
    func parseTweets(data: Any) -> [Tweet]? {
        var tweets = [Tweet]()
        
        let json = JSON(data)
        if let responses = json["data"].array {
            for response in responses {
                if (response.dictionary != nil) {
                    let tweet = Tweet(json: response)!
                    tweets.append(tweet)
                } else {
                    return nil
                }
            }
            return tweets
        } else {
            print ("parseTweets - error: какой-то косячок")
        }
        
        return nil
    }
    
}
