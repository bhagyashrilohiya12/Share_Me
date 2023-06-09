import UIKit
import Flutter

import Firebase

import UIKit
 
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
      
      FirebaseApp.configure()
      
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
      
      GMSServices.provideAPIKey("AIzaSyCDNxEwDYyyrLo3ZCQF7twkgVNWuy0sMn8")
      
      
    GeneratedPluginRegistrant.register(with: self)
      
      
  
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
