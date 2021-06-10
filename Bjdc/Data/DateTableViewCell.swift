//
//  DateTableViewCell.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/5/25.
//

import UIKit

class DateTableViewCell: UITableViewCell {

    @IBOutlet weak var positionModel: UILabel!
    @IBOutlet weak var positionStatus: UIImageView!
    @IBOutlet weak var positionKind: UILabel!
    @IBOutlet weak var positionTime: UILabel!
    
    @IBOutlet weak var viewDataBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
    
}
