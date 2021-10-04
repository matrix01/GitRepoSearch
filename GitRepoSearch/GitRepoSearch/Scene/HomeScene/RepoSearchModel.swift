import Foundation

class RepoSearchModel: ViewModel {
    private(set) var items: [Item]?
    
    func getRepositoryList(searchText: String, completion: @escaping ResultHandler<Void, Error>) {
        provider.requestNetworkTask(endpoint: .search(searchText: searchText),
                                    type: Repository.self) {[weak self] response in
            switch response {
            case.success(let repository):
                self?.items = repository.items
                completion(Swift.Result.success(Void()))
            case .failure(let error):
                completion(Swift.Result.failure(error))
            }
        }
    }
    
    func resetItems() {
        items = nil
    }
    
    var repoCellViewModels: [RepoCellViewModel] {
        return items?.compactMap{ $0 }
        .map { RepoCellViewModel(avatarURL: $0.owner?.avatarURL ?? "",
                                 repoURL: $0.htmlURL ?? "")} ?? []
    }
}
