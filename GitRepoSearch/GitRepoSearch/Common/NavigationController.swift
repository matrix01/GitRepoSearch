import UIKit

class NavigationController: UINavigationController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationBar.layer.shadowColor = UIColor.black.cgColor
        interactivePopGestureRecognizer?.delegate = nil
        navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        let appearance = UINavigationBarAppearance()
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
    }
}

extension UINavigationController {
    func forceUpdateNavBar() {
        DispatchQueue.main.async {
            self.navigationBar.sizeToFit()
        }
      }
}
