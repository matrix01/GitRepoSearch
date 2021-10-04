import UIKit

class RepoSearchController: ViewController {
    
    @IBOutlet private var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    private var refreshControl = UIRefreshControl()
    private var dataSource: UITableViewDiffableDataSource<Section, RepoCellViewModel>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        syncUserData()
        bindDataSource()
    }
    
    private func setupViews() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        
        let cellNib = UINib(nibName: "RepoCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: RepoCell.reuseIdentifier)
        tableView.delegate = self
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc private func refresh(_ sender: AnyObject) {
        syncUserData()
    }
    @objc func syncUserData() {
        guard let viewModel = viewModel as? RepoSearchModel,
              let newSearchText = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                  return
              }
        if newSearchText.isEmpty {
            viewModel.resetItems()
            DispatchQueue.global().async {[weak self] in
                guard let self = self else { return }
                self.reloadData()
            }
            return
        }
        viewModel.getRepositoryList(searchText: newSearchText) {[weak self] result in
            guard let self = self else { return }
            self.endRefresh()
            switch result {
            case .success:
                self.reloadData()
            case .failure(let error):
                self.showAlert(message: error.localizedDescription)
            }
        }
    }
    
    private func showAlert(message: String) {
        DispatchQueue.main.async {
            self.showAlert(title: "Error", message: message)
        }
    }
    
    func bindDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider:
                                                    { (tableView, indexPath, userCellModel) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RepoCell.reuseIdentifier,
                                                           for: indexPath) as? RepoCell else {
                return UITableViewCell()
            }
            cell.viewModel = userCellModel
            return cell
        })
    }
    
    private func reloadData() {
        guard let viewModel = viewModel as? RepoSearchModel else { return }
        var snapshot = NSDiffableDataSourceSnapshot<Section, RepoCellViewModel>()
        snapshot.appendSections([.first])
        
        let setFirst = Set(snapshot.itemIdentifiers)
        let newModels = snapshot.itemIdentifiers + viewModel.repoCellViewModels.filter { !setFirst.contains($0) }
        snapshot.appendItems(newModels, toSection: .first)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func endRefresh() {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
        }
    }
}

extension RepoSearchController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = dataSource?.snapshot().itemIdentifiers[safe: indexPath.row],
           let url = URL(string: item.repoURL){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

extension RepoSearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(syncUserData), object: nil)
        perform(#selector(syncUserData), with: nil, afterDelay: 0.7)
    }
}
