//
//  CuentasViewCell.swift
//  Mi Salud
//
//  Created by ITMED on 11/8/18.
//  Copyright © 2018 ITMED. All rights reserved.
//

import UIKit

class CuentasViewCell: UITableViewCell {

    @IBOutlet weak var nombre_cuenta_label: UILabel!
    @IBOutlet weak var fecha_activacion_label: UILabel!
    @IBOutlet weak var fecha_vencimiento_label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
