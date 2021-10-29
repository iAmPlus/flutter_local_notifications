import UIKit
import Flutter
import flutter_local_notifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate
{
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if #available(iOS 10.0, *) {
        
      UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      
    // let eventChannel = FlutterEventChannel.init(name: "notification_listener", binaryMessenger: controller.binaryMessenger)
    
  //    eventChannel.setStreamHandler(FlutterLocalNotificationsPlugin.init())
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

extension AppDelegate : FlutterStreamHandler
{
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        
        return nil
    }
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
}
