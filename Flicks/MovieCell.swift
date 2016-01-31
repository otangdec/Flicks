//
//  MovieCell.swift
//  Flicks
//
//  Created by Oranuch on 1/5/16.
//  Copyright © 2016 horizon. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var castNamesLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var ratingView: UIImageView!
    @IBOutlet weak var unratedView: UIImageView!

    @IBOutlet weak var runtimeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
