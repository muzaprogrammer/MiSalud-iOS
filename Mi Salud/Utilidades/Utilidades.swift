//
//  Utilidades.swift
//  Mi Salud
//
//  Created by ITMED on 6/8/18.
//  Copyright © 2018 ITMED. All rights reserved.
//

import UIKit

class Utilidades: UIView {
    
    func marge_text_field(margen : Int) -> UIView {
        return UIView(frame: CGRect(x: 0, y: 0, width: margen, height: 38))
    }
    
    func alerta_personalizada(mensaje : String!) -> UIAlertController {
        let alert = UIAlertController(title : "Error", message : mensaje, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cerrar", style : UIAlertAction.Style.default, handler : nil))
        return alert
    }
    
    func indicador_carga_actividad(mensaje : String) -> UIAlertController {
        let alert = UIAlertController(title: nil, message : mensaje, preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        return alert
    }
    
    func formato_fecha(fecha : Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY/MM/dd"
        return dateFormatter.string(from: fecha)
    }
    
    func obtener_dia_semana(fecha : Date) -> Int{
        return Calendar.current.component(.weekday, from: fecha)
    }
    
    func es_correo_valido(correo_electronico:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let test_correo_electronico = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return test_correo_electronico.evaluate(with: correo_electronico)
    }
    
}
