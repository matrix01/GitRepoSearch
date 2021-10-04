import UIKit

class ViewController: UIViewController, Navigatable {
    var viewModel: ViewModel?
    var navigator: Navigator?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func setup(viewModel: ViewModel?, navigator: Navigator) {
        self.viewModel = viewModel
        self.navigator = navigator
    }
}

