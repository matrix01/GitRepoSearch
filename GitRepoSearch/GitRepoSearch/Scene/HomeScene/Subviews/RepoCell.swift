import UIKit

class RepoCell: UITableViewCell {

    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    var viewModel: RepoCellViewModel? {
        didSet {
            bindViewModel()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        separatorInset = UIEdgeInsets(top: 0, left: 80, bottom: 0, right: 0)
    }
    
    func bindViewModel() {
        guard let viewModel = self.viewModel else { return }
        nameLabel.text = viewModel.repoURL
        if let url = viewModel.imageURL {
            userImageView.load(url: url, placeholder: nil, cache: nil)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
