import UIKit
import Foundation

// MARK: UIStoryboard extensions
enum Storyboard: String {
    case Repo
    
    var viewController: UIViewController? {
        UIStoryboard.init(name: self.rawValue, bundle: nil)
            .instantiateInitialViewController()
    }
}
