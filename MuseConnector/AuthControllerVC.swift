import UIKit
import MessageUI


class AuthControllerVC: UIViewController, UIWebViewDelegate,  MFMailComposeViewControllerDelegate {
    var container: PageController!
    var webV: UIWebView!

    @IBOutlet weak var sendFeedbackButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().statusBarHidden = false
        self.view.frame =
            CGRectMake(0, 0, UIScreen.mainScreen().bounds.width,  UIScreen.mainScreen().bounds.height)
        logoutButton.addTarget(self, action: "logout", forControlEvents: .TouchUpInside)
        sendFeedbackButton.addTarget(self, action: "sendEmail", forControlEvents: .TouchUpInside)


        self.webV = UIWebView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
        webV.delegate = self;
        self.view.addSubview(webV)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["slackmoji@shtaff.com"])
        mailComposerVC.setSubject("Feedback")
        mailComposerVC.setMessageBody("This is my feedback!", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func logout()
    {
       
        MainStore.removeAccessToken()
        self.webV.hidden = false
        navigateToAuthUrl()
    }
    
    func sendEmail () {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBOutlet weak var LoginWithSlack: UIButton!
    
    
    @IBAction func navigateToAuthUrl()
    {
        if MainStore.getAccessToken() == nil {
            
            let authUrl = "<auth_url>"
            let request = NSMutableURLRequest(URL: NSURL(string: authUrl)!)
            self.webV.loadRequest(request)

        }
            
        else {
            self.webV.hidden = true
            
            if let mySwipeVC = self.container  {
                mySwipeVC.goToRightView()
            }

            
        }
    

    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(webV: UIWebView)
    {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
        // Back to server after OAuth flow
        let currentUrl = webV.request?.URL?.absoluteString
        
        let BaseUrl = "<server_url>"
        
        if currentUrl?.hasPrefix(BaseUrl) ?? false
        {
            let jsForDetectingError = "typeof (function (){ try { return JSON.parse(document.body.innerText); } catch (e) { return {}; } })().status === \"undefined\""
            
            if self.webV?.stringByEvaluatingJavaScriptFromString(jsForDetectingError) == "true"
            {
                let jsonString = self.webV?.stringByEvaluatingJavaScriptFromString("document.body.innerText")
                let jsonStringData = jsonString?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                
                // check for valid JSON response
                do {
                    let jsonObject = try NSJSONSerialization.JSONObjectWithData(jsonStringData!, options: NSJSONReadingOptions.MutableContainers) as? DictObject
                    
                    self.webV?.stringByEvaluatingJavaScriptFromString("document.body.innerHTML=\"<br><br><br><br><p style=\'text-align:center;font-family:Avenir;font-size:2rem;\'>Logging Out...</h2>\";")
                    
                    print(jsonObject)
                    let token = jsonObject!["access_token"] as? String ?? ""
                    
                    MainStore.setAccessToken(token)
                    
                    SlackAPI.getUserInfo(token) { ( userBox: Box<DictObject>) in
                        userBox.map { (userInfo) in
                            let userID = self.getUniqueId(userInfo)
                            let userObj = self.getUserObj(userInfo)
                            self.container.mixpanel.identify(userID)
                            self.container.mixpanel.people.set(userObj)
                            self.container.mixpanel.registerSuperProperties(userInfo)
                        }
                    }
                    self.webV.hidden = true
                    
                    if let mySwipeVC = self.container  {
                        mySwipeVC.goToRightView()
                    }

                } catch let error {
                    print("got an error creating the request: \(error)")
                }
            }
        }
    }
    
    func getUniqueId(userInfo: DictObject) -> String  {
        let email :String = userInfo["user"]?["profile"]!!["email"] as? String ?? ""
        let teamID :String = userInfo["user"]?["team_id"] as? String ?? ""
        return teamID + "-" + email
    
    }
    
    func getUserObj(userInfo: DictObject) -> DictString  {
        let email :String = userInfo["user"]?["profile"]!!["email"] as? String ?? ""
        //let firstName = email
        let firstName :String = userInfo["user"]?["profile"]!!["first_name"] as? String ?? ""
        let lastName :String = userInfo["user"]?["profile"]!!["last_name"] as? String ?? ""
        let teamID :String = userInfo["user"]?["team_id"] as? String ?? ""
        
        let userObj: DictString = ["email":email,"first_name":firstName,"last_name":lastName,"team_id":teamID]
        return userObj
        
    }
    
    
}