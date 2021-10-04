import UIKit

final class Application: NSObject {
    static let shared = Application()
    var window: UIWindow?
    var provider: Networking?
    let navigator: Navigator

    override private init() {
        navigator = Navigator.default
        super.init()
        updateProvider()
    }

    private func updateProvider() {
        provider = Networking()
    }

    func presentInitialScreen(in window: UIWindow?) {
        guard let window = window, let provider = provider else {
            print("Could not init screen")
            return
        }
        self.window = window
        let viewModel = RepoSearchModel(provider: provider)
        self.navigator.show(segue: .repo(viewModel: viewModel), sender: nil, transition: .root(in: window))
    }
}
