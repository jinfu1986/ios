//
//  UserCell.swift
//  Hivecast
//
//  Created by Mingming Wang on 7/16/17.
//  Copyright © 2017 Mingming Wang. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbImageView: AsyncImageView!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var actionButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
