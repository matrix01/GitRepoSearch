import Foundation

class ViewModel: NSObject {

    let provider: NetworkingProtocol

    init(provider: NetworkingProtocol) {
        self.provider = provider
        super.init()
    }
}
