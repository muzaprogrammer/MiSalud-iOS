//
//  CambiarContraseniaController.swift
//  Mi Salud
//
//  Created by ITMED on 9/8/18.
//  Copyright © 2018 ITMED. All rights reserved.
//

import UIKit
import SQLite

class CambiarContraseniaController: UIViewController, UITextFieldDelegate {

    let URLs : Uris = Uris()
    let utilidades : Utilidades = Utilidades()
    
    var contraseniaActual : String = ""
    var idExpediente : Int = 0;
    var idAsignacionMembresia : Int = 0
    
    @IBOutlet weak var contrasenia_actual_field: UITextField!
    @IBOutlet weak var contrasenia_nueva_field: UITextField!
    @IBOutlet weak var contrasenia_nueva2_field: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var objUsuario : Usuario!
        if let usuarios : AnySequence<Row> = UsuariosEntity.shared.queryAll()
        {
            for eachuser in usuarios{
                objUsuario = UsuariosEntity.shared.getUsuario(usuario: eachuser)
            }
        }
        contraseniaActual = objUsuario.contrasenia!
        idExpediente = objUsuario.idExpediente!
        idAsignacionMembresia = objUsuario.idAsignacionMembresia!
        
        contrasenia_actual_field.delegate = self
        contrasenia_nueva_field.delegate = self
        contrasenia_nueva2_field.delegate = self
        
        contrasenia_actual_field.leftView = utilidades.marge_text_field(margen : 5)
        contrasenia_actual_field.leftViewMode = UITextField.ViewMode.always
        
        contrasenia_nueva_field.leftView = utilidades.marge_text_field(margen : 5)
        contrasenia_nueva_field.leftViewMode = UITextField.ViewMode.always
        
        contrasenia_nueva2_field.leftView = utilidades.marge_text_field(margen : 5)
        contrasenia_nueva2_field.leftViewMode = UITextField.ViewMode.always

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func evento_click(_ sender: UITapGestureRecognizer) {
        contrasenia_actual_field.resignFirstResponder()
        contrasenia_nueva_field.resignFirstResponder()
        contrasenia_nueva2_field.resignFirstResponder()
    }
    
    @IBAction func evento_cambiar_contrasenia(_ sender: UIBarButtonItem) {
        let refreshAlert = UIAlertController(title: "Confirmación", message: "¿Estas seguro de cambiar la contraseña?", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Si", style: .default, handler: { (action: UIAlertAction!) in
            if(self.contraseniaActual == self.contrasenia_actual_field.text){
                if(!(self.contrasenia_nueva_field.text?.isEmpty)! && !(self.contrasenia_nueva2_field.text?.isEmpty)!){
                    if(self.contrasenia_nueva_field.text == self.contrasenia_nueva2_field.text){
                        self.present(self.utilidades.indicador_carga_actividad(mensaje: "Guardando cambios"), animated: true, completion: nil)
                        self.cambiar_contrasenia()
                    }else{
                        self.present(self.utilidades.alerta_personalizada(mensaje: "Las contraseñas no son iguales"), animated: true, completion: nil)
                    }
                }else{
                    self.present(self.utilidades.alerta_personalizada(mensaje: "Por favor ingrese su contraseñas nueva"), animated: true, completion: nil)
                    
                }
            }else{
                self.present(self.utilidades.alerta_personalizada(mensaje: "Las contraseña ingresada es incorrecta"), animated: true, completion: nil)
            }
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func cambiar_contrasenia(){
        let postString = "idExpediente=\(idExpediente)&idAsignacionMembresia=\(idAsignacionMembresia)&contrasenia=\(contrasenia_nueva_field.text ?? "")"
        let url = URL(string: URLs.url_cambiar_contrasenia())!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"//
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("solicitud fallida \(String(describing: error))")//manejamos el error
                return
            }
            do {
                let response = try JSONDecoder().decode(Respuesta.self, from: data)
                DispatchQueue.main.sync {
                    if(response.mensaje == "success"){
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                            self.dissmissActivityIndicator()
                        })
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                            let refreshAlert = UIAlertController(title: "Exito", message: "Contraseña actualizada!", preferredStyle: UIAlertController.Style.alert)
                            refreshAlert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { (action: UIAlertAction!) in
                                UsuariosEntity.shared.updateCorreoContraseniaUsuario(id: self.idExpediente, password: self.contrasenia_nueva_field.text!)
                            }))
                            self.present(refreshAlert, animated: true, completion: nil)
                        })
                    }else{
                        self.present(self.utilidades.alerta_personalizada(mensaje: "La contraseña no pudo ser actualizada."), animated: true, completion: nil)
                    }
                }
            } catch let parseError {
                print("error parsing: \(parseError)")
                let responseString = String(data: data, encoding: .utf8)
                print("response : \(String(describing: responseString))")
                self.present(self.utilidades.alerta_personalizada(mensaje: "Ha ocurrido un error, por favor intentelo nuevamente."), animated: true, completion: nil)
            }
        }
        task.resume()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == contrasenia_actual_field){
            contrasenia_nueva_field.becomeFirstResponder()
        }else if(textField == contrasenia_nueva_field){
            contrasenia_nueva2_field.becomeFirstResponder()
        }else{
            contrasenia_nueva2_field.resignFirstResponder()
        }
        return true
    }
    
    func dissmissActivityIndicator(){
        dismiss(animated: false, completion: nil)
    }
}
