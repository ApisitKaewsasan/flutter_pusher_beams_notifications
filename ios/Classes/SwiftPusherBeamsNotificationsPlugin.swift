import Flutter
import UIKit
import PushNotifications

public class SwiftPusherBeamsNotificationsPlugin: NSObject, FlutterPlugin {
 
    var instanceId : String?
    var beamsClient = PushNotifications.shared

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "pusher_beams_notifications", binaryMessenger: registrar.messenger())
        let instance = SwiftPusherBeamsNotificationsPlugin()
        
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addApplicationDelegate(instance)
        
        // To Init Registration
        PushNotifications.shared.registerForRemoteNotifications()
    }
    
    

    
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    print("ccccza007")
        self.beamsClient.registerDeviceToken(deviceToken)
    }

    private func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        self.beamsClient.handleNotification(userInfo: userInfo)
        myCallbackForReceivedMessages(userInfo: userInfo)
    }

    func myCallbackForReceivedMessages(userInfo: [AnyHashable: Any]) {
       
            let message = extractUserInfo(userInfo: userInfo)
        print("New message: \(message.title), \(message.body)");
        }

       func extractUserInfo(userInfo: [AnyHashable : Any]) -> (title: String, body: String) {
           var info = (title: "", body: "")
           guard let aps = userInfo["aps"] as? [String: Any] else { return info }
           guard let alert = aps["alert"] as? [String: Any] else { return info }
           let title = alert["title"] as? String ?? ""
           let body = alert["body"] as? String ?? ""
           info = (title: title, body: body)
           return info
       }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      
        
        let unwrappedArgs = call.arguments ?? "Nothing here"
        
        switch call.method {
        case "start":
            self.start(result: result, newInstanceId: String(describing: unwrappedArgs))
        case "setOnMessageReceivedListener":
            self.setOnMessageReceivedListener(result: result)
        case "stop":
            self.stop(result: result)
        case "addDeviceInterest":
            self.addDeviceInterest(result: result, interest: String(describing: unwrappedArgs))
        case "removeDeviceInterest":
            self.removeDeviceInterest(result: result, interest: String(describing: unwrappedArgs))
        case "getDeviceInterests":
            self.getDeviceInterests(result: result)
        case "setDeviceInterests":
            self.setDeviceInterests(result: result, interests: unwrappedArgs as! [String])
        case "clearDeviceInterests":
            self.clearDeviceInterests(result: result)
        case "clearAllState":
            self.clearAllState(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
        
    }
    
    private func start(result: FlutterResult, newInstanceId: String) {
        instanceId = newInstanceId
        
        self.beamsClient.start(instanceId: newInstanceId)
        print("Pusher Beams start! "+newInstanceId)
        result(nil)
    }
    private func setOnMessageReceivedListener(result: FlutterResult){
        print("setOnMessageReceivedListener")
     
//        print("werfvref "+remoteNotificationType)
        result(nil)
    }
    
    private func stop(result: FlutterResult) {
        self.beamsClient.stop {
            print("Pusher Beams stopped!")
        }
        
        result(nil)
    }
    
    private func addDeviceInterest(result: FlutterResult, interest: String) {
        try? self.beamsClient.addDeviceInterest(interest: interest)
        
        result(nil)
    }
    
    private func removeDeviceInterest(result: FlutterResult, interest: String) {
        try? self.beamsClient.addDeviceInterest(interest: interest)
        
        result(nil)
    }
    
    private func getDeviceInterests(result: FlutterResult) {
        result(self.beamsClient.getDeviceInterests())
    }
    
    private func setDeviceInterests(result: FlutterResult, interests: [String]) {
        try? self.beamsClient.setDeviceInterests(interests: interests)
        
        result(nil)
    }
    
    private func clearDeviceInterests(result: FlutterResult) {
        try? self.beamsClient.clearDeviceInterests()
        
        result(nil)
    }
    
    private func clearAllState(result: FlutterResult) {
        self.beamsClient.clearAllState {
            print("Pusher Beams State cleared!")
        }
        
        result(nil)
    }
}
