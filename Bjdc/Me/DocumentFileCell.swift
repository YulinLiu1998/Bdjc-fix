//
//  DocumentFileCell.swift
//  BDJC-Test
//
//  Created by mbp on 2021/10/26.
//

import UIKit

class DocumentFileCell: UITableViewCell {
    
    
    @IBOutlet weak var fileName: UILabel!
    
    @IBOutlet weak var check: UIButton!
    
    @IBOutlet weak var shareBtn: UIButton!
    
    @IBOutlet weak var deletItem: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
