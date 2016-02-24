import Foundation

private let AppGroupIdentifier: String = "<your.identifier>"

private let AccessToken: String = "accessToken"
private let UserInfo: String = "userInfo"
private let MixpanelUser: String = "mixpanelUser"
private let MixpanelProps: String = "mixpanelProps"

private let AppSettings: String = "appSettings"
private let UserGroups: String = "userGroups"
private let UserChannels: String = "userChannels"
private let RecentlyUsedChannel: String = "usedChannels"


class MainStore {
    
    static func getGroupContainer() -> NSUserDefaults {
        return NSUserDefaults(suiteName: AppGroupIdentifier)!
    }
    
    static func getAccessToken() -> String? {
        return self.getGroupContainer().stringForKey(AccessToken)
    }
    
    static func setAccessToken(accessToken: String) {
        self.getGroupContainer().setObject(accessToken, forKey: AccessToken)
    }
    
    static func getRecentlyUsedChannels() -> [ChannelItem]? {
        return self.getGroupContainer().objectForKey(RecentlyUsedChannel) as? [ChannelItem]
    }
    
    static func setRecentlyUsedChannels(usedChannel: [ChannelItem]) {
        self.getGroupContainer().setObject(usedChannel, forKey: RecentlyUsedChannel)

    }
    
    
    static func removeAccessToken() {
        if self.getAccessToken() != nil {
            self.getGroupContainer().removeObjectForKey(AccessToken)
        }
    }
    
    static func getUserInfo() -> DictObject? {
        return self.getGroupContainer().objectForKey(UserInfo) as? DictObject
    }
    
    static func setUserInfo(userInfo: DictObject) {
        self.getGroupContainer().setObject(userInfo, forKey: UserInfo)
    }
    
    static func removeUserInfo() {
        if self.getUserInfo() != nil {
            self.getGroupContainer().removeObjectForKey(UserInfo)
        }
    }
    
    static func getUserGroups() -> [GroupItem]? {
        return self.getGroupContainer().objectForKey(UserGroups) as? [GroupItem]
    }
    
    static func setUserGroups(userGroups: [GroupItem]) {
        self.getGroupContainer().setObject(userGroups, forKey: UserGroups)
    }

    static func getUserChannels() -> [ChannelItem]? {
        return self.getGroupContainer().objectForKey(UserChannels) as? [ChannelItem]
    }
    
    static func setUserChannels(userChannels: [ChannelItem]) {
        self.getGroupContainer().setObject(userChannels, forKey: UserChannels)
    }
    
}
