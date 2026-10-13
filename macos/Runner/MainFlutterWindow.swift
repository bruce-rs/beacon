import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    self.minSize = NSSize(width: 700, height: 600)

    AppDelegate.menuChannel = FlutterMethodChannel(
      name: "com.beacon/menu",
      binaryMessenger: flutterViewController.engine.binaryMessenger
    )

    // Revealing in Finder rather than opening the URL: a sandboxed app may read
    // ~/Downloads with the downloads entitlement, but NSWorkspace.open() on that
    // folder is refused ("does not have permission to open").
    let filesChannel = FlutterMethodChannel(
      name: "com.beacon/files",
      binaryMessenger: flutterViewController.engine.binaryMessenger
    )
    filesChannel.setMethodCallHandler { call, result in
      switch call.method {
      case "revealFolder":
        guard let path = (call.arguments as? [String: Any])?["path"] as? String else {
          result(false)
          return
        }
        let url = URL(fileURLWithPath: path, isDirectory: true)
        NSWorkspace.shared.activateFileViewerSelecting([url])
        result(true)
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
