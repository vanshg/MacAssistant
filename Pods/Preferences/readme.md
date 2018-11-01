# Preferences

> Add a preferences window to your macOS app in minutes

<img src="screenshot.gif" width="628" height="416">

Just pass in some view controllers and this package will take care of the rest.


## Requirements

- macOS 10.12+
- Xcode 10+
- Swift 4.2+


## Install

#### SPM

```swift
.package(url: "https://github.com/sindresorhus/Preferences", from: "0.2.0")
```

#### Carthage

```
github "sindresorhus/Preferences"
```

#### CocoaPods

```ruby
pod 'Preferences'
```

<a href="https://www.patreon.com/sindresorhus">
	<img src="https://c5.patreon.com/external/logo/become_a_patron_button@2x.png" width="160">
</a>


## Usage

*Run the `PreferencesExample` target in Xcode to try a live example.*

First, create a couple of view controllers for the preference panes you want. The only difference from implementing a normal view controller is that you have to add the `Preferenceable` protocol and implement the `toolbarItemTitle` and `toolbarItemIcon` getters, as shown below.

`GeneralPreferenceViewController.swift`

```swift
import Cocoa
import Preferences

final class GeneralPreferenceViewController: NSViewController, Preferenceable {
	let toolbarItemTitle = "General"
	let toolbarItemIcon = NSImage(named: NSImage.preferencesGeneralName)!

	override var nibName: NSNib.Name? {
		return "GeneralPreferenceViewController"
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		// Setup stuff here
	}
}
```

`AdvancedPreferenceViewController.swift`

```swift
import Cocoa
import Preferences

final class AdvancedPreferenceViewController: NSViewController, Preferenceable {
	let toolbarItemTitle = "Advanced"
	let toolbarItemIcon = NSImage(named: NSImage.advancedName)!

	override var nibName: NSNib.Name? {
		return "AdvancedPreferenceViewController"
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		// Setup stuff here
	}
}
```

In the `AppDelegate`, initialize a new `PreferencesWindowController` and pass it the view controllers. Then add an action outlet for the `Preferences…` menu item to show the preferences window.

`AppDelegate.swift`

```swift
import Cocoa
import Preferences

@NSApplicationMain
final class AppDelegate: NSObject, NSApplicationDelegate {
	@IBOutlet private var window: NSWindow!

	let preferencesWindowController = PreferencesWindowController(
		viewControllers: [
			GeneralPreferenceViewController(),
			AdvancedPreferenceViewController()
		]
	)

	func applicationDidFinishLaunching(_ notification: Notification) {}

	@IBAction
	func preferencesMenuItemActionHandler(_ sender: NSMenuItem) {
		preferencesWindowController.showWindow()
	}
}
```


## API

```swift
protocol Preferenceable: AnyObject {
	var toolbarItemTitle: String { get }
	var toolbarItemIcon: NSImage { get }
}

class PreferencesWindowController: NSWindowController {
	init(viewControllers: [Preferenceable])
	func showWindow()
	func hideWindow()
}
```


## FAQ

### How is it better than [`MASPreferences`](https://github.com/shpakovski/MASPreferences)?

- Written in Swift. *(No bridging header!)*
- Swifty API using a protocol.
- Fully documented.
- The window title is automatically localized by using the system string.
- Less code (and less chance of bugs) as it uses `NSTabView` instead of manually implementing the toolbar and view switching.


## Related

- [Defaults](https://github.com/sindresorhus/Defaults) - Swifty and modern UserDefaults
- [LaunchAtLogin](https://github.com/sindresorhus/LaunchAtLogin) - Add "Launch at Login" functionality to your macOS app
- [DockProgress](https://github.com/sindresorhus/DockProgress) - Show progress in your app's Dock icon
- [More…](https://github.com/search?q=user%3Asindresorhus+language%3Aswift)

You might also like my [apps](https://sindresorhus.com/#apps).


## License

MIT © [Sindre Sorhus](https://sindresorhus.com)
