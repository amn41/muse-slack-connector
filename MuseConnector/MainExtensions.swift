import Foundation

typealias DictObject = [String: AnyObject]
typealias DictString = [String: String]
typealias GroupItem = DictObject
typealias ChannelItem = DictObject


struct Box<T> {
    let value: T?
    let errorCode: Int?
    
    func hasError() -> Bool {
        return errorCode != nil
    }
    func map<G>(completion: (T) -> G) -> Box<G> {
        if !self.hasError() {
            return Box<G>(value: completion(self.value!), errorCode: nil)
        } else {
            return Box<G>(value: nil, errorCode: self.errorCode)
        }
    }
    
    static func ok(value: T) -> Box<T> {
        return Box<T>(value: value, errorCode: nil)
    }
    static func ok(value: T?) -> Box<T> {
        if value == nil {
            return Box.error(-1)
        } else {
            return Box.ok(value!)
        }
    }
    static func error(errorCode: Int) -> Box<T> {
        return Box<T>(value: nil, errorCode: errorCode)
    }
    static func error(errorCode: Int?) -> Box<T> {
        if errorCode == nil {
            return Box.error(-1)
        } else {
            return Box.error(errorCode!)
        }
    }
    
}

class BoardTemplate {
    var title: String
    var description: String
    
    required init(title: String, description: String) {
        self.title = title
        self.description = description
    }
    
    func asDictionary() -> DictString {
        return [
            "title": title,
            "description": description
        ]
    }
    
}




struct SharingOptionsInfo {
//    let image: UIImage?
    let fullName: String
    let imageId: String
    let optionId: String

    init(optionId: String,fullName: String, imageId: String) {
        self.optionId = optionId
//        self.image = UIImage(named: imageId)
        self.fullName = fullName
        self.imageId = imageId

    }
}



extension NSURL
{
    struct ValidationQueue {
        static var queue = NSOperationQueue()
    }
    
    class func validateUrl(urlString: String?, completion:(success: Bool, urlString: String? , error: NSString) -> Void)
    {
        // Description: This function will validate the format of a URL, re-format if necessary, then attempt to make a header request to verify the URL actually exists and responds.
        // Return Value: This function has no return value but uses a closure to send the response to the caller.
        
        var formattedUrlString : String?
        
        // Ignore Nils & Empty Strings
        if (urlString == nil || urlString == "")
        {
            completion(success: false, urlString: nil, error: "URL String was empty")
            return
        }
        
        // Ignore prefixes (including partials)
        let prefixes = ["http://www.", "https://www.", "www."]
        for prefix in prefixes
        {
            if ((prefix.rangeOfString(urlString!, options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil)) != nil){
                completion(success: false, urlString: nil, error: "Url String was prefix only")
                return
            }
        }
        
        // Ignore URLs with spaces
        let range = urlString!.rangeOfCharacterFromSet(NSCharacterSet.whitespaceCharacterSet())
        if range != nil {
            completion(success: false, urlString: nil, error: "Url String cannot contain whitespaces")
            return
        }
        
        // Check that URL already contains required 'http://' or 'https://', prepend if it does not
        formattedUrlString = urlString
        if (!formattedUrlString!.hasPrefix("http://") && !formattedUrlString!.hasPrefix("https://"))
        {
            formattedUrlString = "http://"+urlString!
        }
        
        // Check that an NSURL can actually be created with the formatted string
        if let validatedUrl = NSURL(string: formattedUrlString!)
        {
            // Test that URL actually exists by sending a URL request that returns only the header response
            let request = NSMutableURLRequest(URL: validatedUrl)
            request.HTTPMethod = "HEAD"
            ValidationQueue.queue.cancelAllOperations()
            
            NSURLConnection.sendAsynchronousRequest(request, queue: ValidationQueue.queue) { (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                let url = request.URL!.absoluteString
                
                // URL failed - No Response
                if (error != nil)
                {
                    completion(success: false, urlString: url, error: "The url: \(url) received no response")
                    return
                }
                
                // URL Responded - Check Status Code
                if let urlResponse = response as? NSHTTPURLResponse
                {
                    if ((urlResponse.statusCode >= 200 && urlResponse.statusCode < 400) || urlResponse.statusCode == 405)// 200-399 = Valid Responses, 405 = Valid Response (Weird Response on some valid URLs)
                    {
//                        let header = NSString(data: data, encoding: NSUTF8StringEncoding) as String?
//                        println("  url response data: \(header)")
                        completion(success: true, urlString: url, error: "The url: \(url) is valid!")
                        return
                    }
                    else // Error
                    {
                        completion(success: false, urlString: url, error: "The url: \(url) received a \(urlResponse.statusCode) response")
                        return
                    }
                }
            }
        }
    }
}

