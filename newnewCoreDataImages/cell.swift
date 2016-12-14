//
//  cell.swift
//  newnewCoreDataImages
//
//  Created by Cesar on 12/12/16.
//  Copyright © 2016 Cesar. All rights reserved.
//

import UIKit

class cell: UITableViewCell {

    @IBOutlet weak var sentence: UILabel!
   
    @IBOutlet weak var imagee: UIImageView!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
