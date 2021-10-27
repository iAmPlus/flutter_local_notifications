import Flutter
import UIKit
import UserNotifications
import AVFoundation

private var _eventSink: FlutterEventSink?

public class SwiftNotificationManagerPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {

    private override init() {}

    private static let swiftNotificationManagerPlugin: SwiftNotificationManagerPlugin = {
        return SwiftNotificationManagerPlugin()
    }()

    static var shared: SwiftNotificationManagerPlugin {
        return swiftNotificationManagerPlugin
    }

    fileprivate var player: AVAudioPlayer?

    private var prestoredAlarm: NotificationBody?
    private var isFromNotificationLaunch = false
    private var isDefaultAudioConfigurationEnabled: Bool = true

    public static func register(with registrar: FlutterPluginRegistrar) {

        //Event channel for alarm trigger lister
        let eventChannel = FlutterEventChannel(name: "alarm_listener", binaryMessenger: registrar.messenger())
        eventChannel.setStreamHandler(SwiftNotificationManagerPlugin.shared)

        let channel = FlutterMethodChannel(name: "alarmmanager", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(SwiftNotificationManagerPlugin.shared, channel: channel)

        //.. Add Observer for applicationDidBecomeActive.
        NotificationCenter.default.addObserver(SwiftNotificationManagerPlugin.shared, selector: #selector(applicationDidBecomeActive(notification:)), name: NSNotification.Name.init(rawValue: "alarm-applicationDidBecomeActive"), object: nil)
    }

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        _eventSink = events

        //Nead to create Notification Body
        print("onListen(withArguments - ", arguments);

//         if let alarm = prestoredAlarm, let theJSONText = prepareStirngDictFromNotificationPayload(alarm: alarm, appState: "notificaiotn_click_or_by_app_launch") {
//             events(theJSONText)
//             prestoredAlarm = nil
//         }
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        _eventSink = nil
        return nil
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

        switch call.method {

        case "handle_local_notification":
            if let args = call.arguments as? [String: Any],
               let data = args["data"] as? [String: Any],
               let actionIdentifier = args["actionIdentifier"] as? String,
               let app_state = args["app_state"] as? String

            {
                isFromNotificationLaunch = true

                //Convert into notification body and convert into JSONtext and pass into sync
                let notificationBody = NotificationBody(withDictionary: data)


//                 let alarm = getAlarmData(userInfo: data)
//
//                 if (alarm.notification_domain == "alarm") {
//
//                     //..
//                     UNUserNotificationCenter.current().removeAllDeliveredNotifications()
//
//                     //.. Make sure we de-registered all upcoming notifications.
//                     let identifier = deleteAlarm(id: alarm.id, snooze_id: alarm.snooze_id, repeatDays: alarm.repeats, particularDatesInMilliseconds: alarm.particularDatesInMilliseconds)
//                     _ = notificationHelper.removePendingNotification(identifier: identifier)
//                 }

                if (app_state == "foreground") {
                    guard let theJSONText = prepareStringDictFromNotificationPayload(notificationBody: notificationBody, appState: app_state) else {
                        return
                    }
                    _eventSink?(theJSONText)
                }
            }
            break;


        case "enableIOSDefaultAudioSessionConfiguration" :

            if let args = call.arguments as? [String: Any],
               let isEnabled = args["enableIOSDefaultAudioSessionConfiguration"] as? Bool {
                self.isDefaultAudioConfigurationEnabled = isEnabled
            }
            break;

           case "delivered_notifications_info":
            if #available(iOS 10.0, *) {
                UNUserNotificationCenter.current().getDeliveredNotifications {(deliveredNotifications: [UNNotification]) in
                    
                    let arrDeliveredAlarmsKeys = deliveredNotifications.compactMap({($0.request.content.userInfo["key"] as? String ?? "")}).filter({$0 != ""})
                    
                    guard arrDeliveredAlarmsKeys.count > 0 else {
                        return
                    }
                    
                    let dict: [String: Any] = [
                        "delivered_notifications_alarms_key": arrDeliveredAlarmsKeys,
                    ]
                    
                    if let theJSONData = try? JSONSerialization.data(
                        withJSONObject: dict,
                        options: []), let theJSONText = String(data: theJSONData,
                                                               encoding: .utf8 ) {
                        
                        _eventSink?(theJSONText)
                        result(["status": true, "message": "Success"])
                    }
                }
            } else {
                // Fallback on earlier versions
            }
                        break;
        default:
            break;
        }
    }
}

extension SwiftNotificationManagerPlugin {

    @objc fileprivate func applicationDidBecomeActive(notification:Notification) {

        if !(isFromNotificationLaunch) {
            let dict: [String: Any] = [
                "is_iOS_app_launch": true,
            ]

            if let theJSONData = try? JSONSerialization.data(
                withJSONObject: dict,
                options: []), let theJSONText = String(data: theJSONData,
                                                       encoding: .utf8 ) {

                _eventSink?(theJSONText)
            }
        } else {
            isFromNotificationLaunch = false
        }
    }


    fileprivate func playSound(fileName: String) {

        let audioFileDataArr = fileName.components(separatedBy: ".")
        let audioFileName = audioFileDataArr[0]
        let audioFileExtension = (audioFileDataArr.indices.contains(1) ? audioFileDataArr[1] : "wav")

        guard let url = fetchMusicURLEitherFromSoundOrFromBundleDirectory(forResource: audioFileName, withExtension: audioFileExtension) else {
            return
        }

        do {
            print("SwiftAlarmmanagerPlugin isDefaultAudioConfigurationEnabled - \(isDefaultAudioConfigurationEnabled)")
            if (isDefaultAudioConfigurationEnabled) {
                if #available(iOS 10.0, *) {
                    try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                } else {
                    // Fallback on earlier versions
                    
                }
                try AVAudioSession.sharedInstance().setActive(true)
            }

            if (audioFileExtension.lowercased() == "wav") {
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            } else if (audioFileExtension.lowercased() == "caf") {
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.caf.rawValue)
            } else {
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.aiff.rawValue)
            }

            player?.numberOfLoops = -1

            guard let player = player else {
                return
            }

            player.play()

        } catch _ {}
    }

    fileprivate func fetchMusicURLEitherFromSoundOrFromBundleDirectory(forResource: String, withExtension: String) -> URL? {
        let libraryURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first
        let soundFolderURL = libraryURL?.appendingPathComponent("Sounds", isDirectory: true)
        if !FileManager.default.fileExists(atPath: (soundFolderURL?.path ?? "")) {
            return Bundle.main.url(forResource: "alarm_default_sound", withExtension: "wav")
        }
        let musicURL = soundFolderURL?.appendingPathComponent((forResource + "." + withExtension), isDirectory: false)
        if !FileManager.default.fileExists(atPath: (musicURL?.path ?? "")) {
            return Bundle.main.url(forResource: "alarm_default_sound", withExtension: "wav")
        } else {
            return musicURL
        }
    }

    fileprivate func prepareStringDictFromNotificationPayload(notificationBody: NotificationBody, appState: String) -> String? {

        let notificationBodyJSON = notificationBody.toDictionary()
        let dict = ["appState": appState,
                           "data": notificationBodyJSON] as [String : Any?]

        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: dict,
            options: []), let theJSONText = String(data: theJSONData,
                                                   encoding: .utf8 ) {

            return theJSONText
        }
        return nil
    }
}
