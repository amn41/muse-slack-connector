# Muse-Connector

A very simple iOS app for connecting to a Muse headset via Bluetooth and to the Slack API, see [this post](medium.com)

Navigation is based on the [EZSwipeController](https://github.com/goktugyil/EZSwipeController/)

We use the following libraries as Pods:
 - SwiftHTTP
 - SwiftyJSON
 - Mixpanel

You can remove the Mixpanel integration if you're not interested in tracking events.

Slack Authentication happens in the leftmost panel. You will need a simple webserver which performs the OAuth redirects and returns the JSON containing the auth token as the body of a 200 response. 
