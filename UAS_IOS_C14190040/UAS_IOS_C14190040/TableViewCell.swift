//
//  TableViewCell.swift
//  UAS_IOS_C14190040
//
//  Created by Athalia Gracia Santoso on 14/06/22.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var labelgambar: UIImageView!
    @IBOutlet weak var labelnama: UILabel!
    @IBOutlet weak var labelidr: UILabel!
    @IBOutlet weak var labelusd: UILabel!
    @IBOutlet weak var labelsimbol: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
