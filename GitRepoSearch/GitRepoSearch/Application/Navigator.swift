import Foundation
import UIKit

protocol Navigatable {
    var navigator: Navigator? { get set }
}

class Navigator {
    static var `default` = Navigator()
    
    // MARK: - segues list, all app scenes
    enum Scene {
        case repo(viewModel: ViewModel)
    }
    
    enum Transition {
        case root(in: UIWindow)
    }
    
    // MARK: - get a single VC
    func get(segue: Scene) -> UIViewController? {
        switch segue {
        case .repo(let viewModel):
            guard let repoVC = Storyboard.Repo.viewController as? RepoSearchController else {
                return nil
            }
            repoVC.setup(viewModel: viewModel, navigator: self)
            return NavigationController(rootViewController: repoVC)
        }
    }
    
    func pop(sender: UIViewController?, toRoot: Bool = false) {
        if toRoot {
            sender?.navigationController?.popToRootViewController(animated: true)
        } else {
            sender?.navigationController?.popViewController(animated: true)
        }
    }
    
    func dismiss(sender: UIViewController?) {
        sender?.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - invoke a single segue
    func show(segue: Scene, sender: UIViewController?, transition: Transition) {
        if let target = get(segue: segue) {
            show(target: target, sender: sender, transition: transition)
        }
    }
    
    private func show(target: UIViewController, sender: UIViewController?, transition: Transition) {
        switch transition {
        case .root(in: let window):
            UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                window.rootViewController = target
            }, completion: nil)
        }
    }
}
