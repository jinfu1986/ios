//
//  VideoCell.swift
//  Hivecast
//
//  Created by Mingming Wang on 7/1/17.
//  Copyright © 2017 Mingming Wang. All rights reserved.
//

import UIKit

class VideoCell: UITableViewCell {
    @IBOutlet weak var thumbImageView: AsyncImageView!
    @IBOutlet weak var userImageView: AsyncImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
