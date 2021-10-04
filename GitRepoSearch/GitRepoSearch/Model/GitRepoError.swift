import Foundation
/// Error
internal enum GitRepoError: Error {
    case emptyData
    case emptyResponse
    case internalError
    case unknown

    var localizedDescription:(title: String, message: String) {
        switch self {
        case .unknown:
            return ("", "Unknowned Error")
        case .emptyData:
            return ("", "Empty data from server")
        case .emptyResponse:
            return ("", "Empty response from server")
        case .internalError:
            return ("", "Internal Error!")
        }
    }
}
