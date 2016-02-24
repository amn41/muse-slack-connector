import Mixpanel

import UIKit
class PageController: EZSwipeController {
    
    let authVC = AuthControllerVC() 
    let statusVC = StatusViewController()
  
    override func setupView() {
        datasource = self
        
    }
    
    func disableSwipingForLeftButtonAtPageIndex(index: Int) -> Bool {
        return false
    }
    /*
    func disableSwipingForRightButtonAtPageIndex(index: Int) -> Bool {
        return false
    }*/
    
    var mixpanel = Mixpanel.sharedInstanceWithToken("<your_mixpanel_token>")
    
    func goToRightView () {
        let currentIndex = stackPageVC.indexOf(currentStackVC)!
        datasource?.clickedRightButtonFromPageIndex?(currentIndex)
        
        if currentStackVC == stackPageVC.last {
            return
        }
        currentStackVC = stackPageVC[currentIndex + 1]
        pageViewController.setViewControllers([currentStackVC], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
    }
    
    func goToLeftView () {
        if currentStackVC == stackPageVC.first {
            return
        }
        let currentIndex = stackPageVC.indexOf(currentStackVC)!
        currentStackVC = stackPageVC[currentIndex - 1]
        pageViewController.setViewControllers([currentStackVC], direction: UIPageViewControllerNavigationDirection.Reverse, animated: true, completion: nil)
        
    }
    
}

extension PageController: EZSwipeControllerDataSource {
    
    func viewControllerData() -> [UIViewController] {
        
        authVC.container = self
        statusVC.container = self
        
        return [authVC,statusVC]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authVC.navigateToAuthUrl()
    }
    
    func isThereAToken () -> Bool {
        
        if MainStore.getAccessToken() != nil {
            return true
        }
        return false
    }
    
    override internal func canBecomeFirstResponder() -> Bool {
        return true
    }

}

