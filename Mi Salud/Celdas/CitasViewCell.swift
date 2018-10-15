//
//  CitasViewCell.swift
//  Mi Salud
//
//  Created by ITMED on 9/8/18.
//  Copyright © 2018 ITMED. All rights reserved.
//

import UIKit

class CitasViewCell: UITableViewCell {

    @IBOutlet weak var nombre_sucursal_label: UILabel!
    @IBOutlet weak var tipo_consulta_label: UILabel!
    @IBOutlet weak var fecha_consulta_label: UILabel!
    @IBOutlet weak var hora_consulta_label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
