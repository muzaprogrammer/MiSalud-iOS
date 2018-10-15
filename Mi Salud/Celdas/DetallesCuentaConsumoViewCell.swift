//
//  DetallesCuentaConsumoViewCell.swift
//  Mi Salud
//
//  Created by ITMED on 11/8/18.
//  Copyright © 2018 ITMED. All rights reserved.
//

import UIKit

class DetallesCuentaConsumoViewCell: UITableViewCell {

    @IBOutlet weak var nombre_producto_label: UILabel!
    @IBOutlet weak var nombre_paciente_label: UILabel!
    @IBOutlet weak var precio_label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
