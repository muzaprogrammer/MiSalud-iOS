//
//  RecetasViewCell.swift
//  Mi Salud
//
//  Created by ITMED on 11/8/18.
//  Copyright © 2018 ITMED. All rights reserved.
//

import UIKit

class RecetasViewCell: UITableViewCell {

    @IBOutlet weak var fecha_label: UILabel!
    @IBOutlet weak var paciente_label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
