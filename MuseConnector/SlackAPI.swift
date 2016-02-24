import Foundation
import CoreLocation
import SwiftHTTP
import SwiftyJSON



let SlackUrl: String = "https://slack.com/api"


class SlackAPI
{
    private static func handleResponseError(res: Response) -> Bool
    {
        //        print("API response code: \(res.statusCode)")
        
        if res.statusCode == 403
        {
            MainStore.removeAccessToken()
        }
        
        if let err = res.error
        {
            print("API response error: \(err.code) \(err.localizedDescription) \(res.URL)")
            return true
        }
        
        return res.statusCode != 200
    }
    
    
    
    static func postToAPI(accessToken: String!,endpoint:String!,extraParams:DictString, completion: ((Box<DictObject>) -> Void)? = nil )
    {
        print("\n  *fetching from API")
        do {
            let url: String = "\(SlackUrl)/\(endpoint)"
            var params: DictString = ["token": accessToken]
            for (key,val) in extraParams {
                params[key]=val
            }
            
            let opt = try HTTP.POST(url, parameters: params)
            
            opt.start { response in
                
                if !self.handleResponseError(response)
                {
                    let data = JSON(data: response.data)
                    print("    response: \(data)")
                    completion?(Box.ok(data.object as! DictObject))
                }
                else
                {
                    completion?(Box.error(response.statusCode))
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    
    
    
    static func testAuthToken(accessToken: String!, completion: ((Box<DictObject>) -> Void)? = nil )
    {
        let endpoint: String = "/auth.test"
        let extraParams: DictString = DictString()
        postToAPI(accessToken,endpoint:endpoint,extraParams: extraParams,completion: completion)
    }

    
    static func fetchUserInfo(accessToken: String!, userId: String!,completion: ((Box<DictObject>) -> Void)? = nil )
    {
        let endpoint: String = "/users.info"
        let extraParams: DictString = ["user":userId]
        postToAPI(accessToken,endpoint:endpoint,extraParams: extraParams,completion: completion)
    }

    
    static func getUserInfo(token: String,completion: Box<DictObject> -> Void) -> Void {
        testAuthToken(token) { (authBox: Box<DictObject>) in
            authBox.map { (authInfo) in
                if let userId = authInfo["user_id"] as? String {
                    fetchUserInfo(token,userId: userId,completion: completion)
                }
            }
        }
        
    }
    
    static func mute(token:String) -> Void {
        let endpoint: String = "/dnd.setSnooze"
        postToAPI(token, endpoint: endpoint, extraParams: ["num_minutes":"10"])
    }
    
    static func unmute(token:String) -> Void {
        let endpoint: String = "/dnd.endSnooze"
        postToAPI(token, endpoint: endpoint, extraParams: DictString())
    }
    
    



}