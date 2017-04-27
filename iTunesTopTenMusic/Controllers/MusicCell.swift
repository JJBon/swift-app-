//
//  MusicCell.swift
//  iTunesTopTenMusic
//
//  Created by mruiz723 on 2/8/16.
//  Copyright © 2016 nextU. All rights reserved.
//

import UIKit

class MusicCell: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var songImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    //MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
