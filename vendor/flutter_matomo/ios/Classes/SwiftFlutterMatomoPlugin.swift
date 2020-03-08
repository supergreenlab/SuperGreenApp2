import Flutter
import UIKit
import MatomoTracker


public class SwiftFlutterMatomoPlugin: NSObject, FlutterPlugin {
  
  var matomoTracker: MatomoTracker? = nil
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_matomo", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterMatomoPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if(call.method.elementsEqual("initializeTracker")){
        let arguments = call.arguments as? NSDictionary
        let url = arguments?["url"] as? String
        let siteId = arguments?["siteId"] as? Int
//      if(matomoTracker == nil){
        matomoTracker = MatomoTracker(siteId: String(siteId!), baseURL: URL(string: url ?? "")!)
        matomoTracker?.logger = DefaultLogger(minLevel: .verbose)
//      }
        result("Matomo:: \(url) initialized successfully.")
    }
    if(call.method.elementsEqual("trackEvent")){
            let arguments = call.arguments as? NSDictionary
            let widgetName = arguments?["widgetName"] as? String
            let eventName =  arguments?["eventName"] as? String
            let eventAction =  arguments?["eventAction"] as? String
        matomoTracker?.track(eventWithCategory:widgetName ?? "", action: eventAction ?? "", name: eventName ?? "", number: 3)
        matomoTracker?.dispatch()
        result("Matomo:: trackScreen event \(eventName) sent")
    }
    if(call.method.elementsEqual("trackScreen")){
        let arguments = call.arguments as? NSDictionary
        let widgetName = arguments?["widgetName"] as? String
        matomoTracker?.track(view:[widgetName ?? ""])
        matomoTracker?.dispatch()
        result("Matomo:: trackScreen screen \(widgetName) sent")
    }
    if(call.method.elementsEqual("trackDownload")){
        result("Matomo:: trackDownload initialized successfully.")
    }
    if(call.method.elementsEqual("trackGoals")){
        result("Matomo:: trackGoals initialized successfully.")
    }
    if(call.method.elementsEqual("dispatchEvents")){
                matomoTracker?.dispatch()
        result("Matomo:: events dispatched")
    }
  }
}
