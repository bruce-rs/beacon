import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  static var menuChannel: FlutterMethodChannel?

  @objc func openSettings(_ sender: Any) {
    AppDelegate.menuChannel?.invokeMethod("openSettings", arguments: nil)
  }

  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
}
