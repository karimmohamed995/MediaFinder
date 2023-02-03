//
//  MediaListCell.swift
//  MediaFinder
//
//  Created by Karim Mohamed on 27/12/2022.
//

import UIKit

class MediaListCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var cellDescriptionLabel: UILabel!
    
    // MARK: - LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
