import Foundation
import UIKit

struct RepoCellViewModel: Hashable {
    var avatarURL: String
    var repoURL: String
    
    static func == (lhs: RepoCellViewModel, rhs: RepoCellViewModel) -> Bool {
        return lhs.repoURL == rhs.repoURL
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(repoURL)
    }
}

extension RepoCellViewModel {
    var imageURL: URL? {
        URL(string: avatarURL)
    }
}
