//
//  ExamenesLaboratorioViewCell.swift
//  Mi Salud
//
//  Created by ITMED on 10/8/18.
//  Copyright © 2018 ITMED. All rights reserved.
//

import UIKit

class ExamenesLaboratorioViewCell: UITableViewCell {

    @IBOutlet weak var tipo_examen_label: UILabel!
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
