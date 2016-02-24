import UIKit
import Foundation

private var myContext = 0


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // muse stuff
    var muse: protocol<IXNMuse>? = nil
    dynamic var manager: IXNMuseManager? = nil
    var loggingListener: LoggingListener? = nil
    var musePickerTimer: NSTimer? = nil
    
    // views
    var window: UIWindow?
    var startVC = PageController()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.rootViewController = self.startVC
        window!.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        //muse?.disconnect(false)
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if (self.manager == nil) {
            print("manager not yet registered")
            self.manager = IXNMuseManager.sharedManager()
        }
        if (self.muse == nil) {
            print("app has no registered muse")
            //musePickerTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(1.5), target: self, selector: "showPicker", userInfo: nil, repeats: false)
        }
        self.loggingListener = LoggingListener(withDelegate: self)
        // just a test
        self.loggingListener?.receiveMuseConnectionPacket(IXNMuseConnectionPacket())
        let keyPath = self.manager?.connectedMusesKeyPath() ?? ""
        self.manager?.addObserver(self, forKeyPath: keyPath, options: [NSKeyValueObservingOptions.New,NSKeyValueObservingOptions.Initial], context: nil)
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.muse = nil
        self.manager?.removeObserver(self, forKeyPath: (manager?.connectedMusesKeyPath()) ?? "")
    }

    func startWithMuse(newMuse :IXNMuse) {//:protocol<IXNMuse>) {
        print("start with Muse called")
        if (self.muse == nil) {
            self.muse = newMuse
        }
        self.musePickerTimer?.invalidate()
        self.musePickerTimer = nil
        self.muse?.registerDataListener(loggingListener!, type: IXNMuseDataPacketType.Concentration)
        self.muse?.registerDataListener(loggingListener!, type: IXNMuseDataPacketType.AlphaAbsolute)
        self.muse?.registerConnectionListener(loggingListener!)
        self.muse?.runAsynchronously()
        
    }
    
    func showPicker() {
        if (self.muse != nil) {
            return
        }
        self.manager?.showMusePickerWithCompletion() { error in
            print("got an error from the picker")
            print(error)
        }
        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>)  {
        
        if keyPath == self.manager?.connectedMusesKeyPath() {
            let connectedMuses = (change![NSKeyValueChangeNewKey] as! NSSet) as Set
            
            if connectedMuses.count > 0 {
                if let muse = connectedMuses.first as? IXNMuse {
                    self.startWithMuse(muse)
                } else {
                    print("couldn't cast connected muse as IXNMuse")
                    print(connectedMuses.first.dynamicType)
                }
            }
        }
    }
    /*
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
         print("looking for Muse")
        if (keyPath ?? "" == manager?.connectedMusesKeyPath() && change != nil) {
            let connectedMuses: Set = ([change![NSKeyValueChangeNewKey]!] as NSSet) as Set
            print("connected muses "+connectedMuses.description)
            if (connectedMuses.count > 0) {
                if let connectedMuse = connectedMuses.first as? IXNMuse {
                    self.startWithMuse(connectedMuse)
                }
            }
        }
    }*/
    
    func sayHi() {
        let alert = UIAlertView.init(title: "Sweet", message: "you are totally creaming", delegate: nil, cancelButtonTitle: "KEWL")
        alert.show()
    }
}

