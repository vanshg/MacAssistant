import Cocoa

public final class PreferencesWindowController: NSWindowController {
	private let tabViewController = PreferencesTabViewController()

	public init(viewControllers: [Preferenceable]) {
		precondition(!viewControllers.isEmpty, "You need to set at least one view controller")

		let window = NSWindow(
			contentRect: (viewControllers[0] as! NSViewController).view.bounds,
			styleMask: [
				.titled,
				.closable
			],
			backing: .buffered,
			defer: true
		)
		super.init(window: window)

		window.title = String(System.localizedString(forKey: "Preferences…").dropLast())
		window.contentView = tabViewController.view

		tabViewController.tabViewItems = viewControllers.map { viewController in
			let item = NSTabViewItem(identifier: viewController.toolbarItemTitle)
			item.label = viewController.toolbarItemTitle
			item.image = viewController.toolbarItemIcon
			item.viewController = viewController as? NSViewController
			return item
		}
		tabViewController.tabStyle = .toolbar
		tabViewController.transitionOptions = [.crossfade, .slideDown]
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	public func showWindow() {
		if !window!.isVisible {
			window?.center()
		}

		showWindow(self)
		NSApp.activate(ignoringOtherApps: true)
	}

	public func hideWindow() {
		close()
	}
}
