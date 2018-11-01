import Cocoa

final class PreferencesTabViewController: NSTabViewController {
	private var tabViewSizes = [String: CGSize]()

	private func setWindowFrame(for viewController: NSViewController) {
		let window = view.window!
		let contentSize = tabViewSizes[viewController.simpleClassName] ?? viewController.view.frame.size
		let newWindowSize = window.frameRect(forContentRect: CGRect(origin: .zero, size: contentSize)).size

		var frame = window.frame
		frame.origin.y += frame.height - newWindowSize.height
		frame.size = newWindowSize
		window.animator().setFrame(frame, display: false)
	}

	override func transition(from fromViewController: NSViewController, to toViewController: NSViewController, options: NSViewController.TransitionOptions = [], completionHandler completion: (() -> Void)? = nil) {
		tabViewSizes[fromViewController.simpleClassName] = fromViewController.view.frame.size

		NSAnimationContext.runAnimationGroup({ context in
			context.duration = 0.5
			setWindowFrame(for: toViewController)
			super.transition(from: fromViewController, to: toViewController, options: [.crossfade, .allowUserInteraction], completionHandler: completion)
		}, completionHandler: nil)
	}
}
