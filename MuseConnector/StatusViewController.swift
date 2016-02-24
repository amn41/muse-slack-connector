import UIKit
import AudioToolbox
import CoreFoundation
import AVFoundation
import Foundation

struct Params{
    static let elementsToAverage: Int = 10
    static let updateInterval: Double = 1.5
    static let averageConcentrationThreshold = 0.15
}

class StatusViewController: UIViewController {

    @IBOutlet weak var concentrationBar: UIProgressView!
    @IBOutlet weak var messageMode: UILabel!
    @IBOutlet weak var messageSlack: UILabel!
    
    var container : PageController!
    var rollingAverage : [Double] = [Double](count: Params.elementsToAverage,repeatedValue: -1.0)
    var currentMode: Int = 0 // 1 means concentrating
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.moveConcentrationBar()
        messageMode.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
        messageMode.numberOfLines = 0
        messageSlack.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
        messageSlack.numberOfLines = 0
        var updateModeTimer = NSTimer.scheduledTimerWithTimeInterval(Params.updateInterval, target: self, selector: Selector("updateView"), userInfo: nil, repeats: true)
        
        self.currentMode = 1
        modeNotFocussed()
        
    }
    
    func rollingAverageConcentration(latestScore:Double) -> Double {
        rollingAverage.insert(latestScore, atIndex: 0)
        rollingAverage.removeLast()
        print(rollingAverage)
        if rollingAverage.contains(-1.0) {
            // not enough data points yet
            return 0.0
        } else {
            let average = rollingAverage.reduce(0.0, combine: {(a,b) in a + b}) / Double(Params.elementsToAverage)
            print("average \(average)")
            return (average)
        }

    }
    
    override func viewWillDisappear(animated: Bool) {
    }
    
    
    override func viewWillAppear(animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateView () {
        if (rollingAverageConcentration(ConcentrationScore) < Params.averageConcentrationThreshold) {
            self.modeNotFocussed()
        } else {
            self.modeFocussed()
        }
        
    }
    
    func modeFocussed () {
        //print("-FOCUSSED-")
        //print(ConcentrationScore)
        if (self.currentMode == 0) {
            self.messageMode.text = "Very good - you're focused! Keep it up! 👏"
            self.messageSlack.text = "Slack is snoozed. 🔇"
            self.concentrationBar.progress = Float(ConcentrationScore)
            self.muteSlack()
            self.currentMode = 1
        }
    }
    
    func modeNotFocussed () {
       //print("-NOT FOCUSSED-")
       //print(ConcentrationScore)
        if (self.currentMode == 1) {
            self.messageMode.text = "You're not in the zone yet. Try to focus on the task at hand! 🙄"
            self.messageSlack.text = "Slack is not snoozed. 📢"
            self.concentrationBar.progress = Float(ConcentrationScore)
            self.unmuteSlack()
            self.currentMode = 0
        }
    }
    
    
    
    func museConnectionOk() -> Bool {
        return true
    }

    func muteSlack() -> Void {
        print("muting slack")
        SlackAPI.mute(MainStore.getAccessToken() ?? "")
    }
    
    func unmuteSlack() -> Void {
        print("unmuting slack")
        SlackAPI.unmute(MainStore.getAccessToken() ?? "")
    }
        
     
}

