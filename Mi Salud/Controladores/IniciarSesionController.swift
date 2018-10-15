//
//  ViewController.swift
//  Mi Salud
//
//  Created by ITMED on 6/8/18.
//  Copyright © 2018 ITMED. All rights reserved.
//

import Foundation
import UIKit
import SQLite

class IniciarSesionController : UIViewController, UITextFieldDelegate {

    @IBOutlet weak var correo_electronico_field: UITextField!
    @IBOutlet weak var contrasenia_field: UITextField!
    let utilidades : Utilidades = Utilidades()
    let URLs : Uris = Uris()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        correo_electronico_field.delegate = self
        contrasenia_field.delegate = self
        
        correo_electronico_field.leftView = utilidades.marge_text_field(margen : 45)
        correo_electronico_field.leftViewMode = UITextField.ViewMode.always
        
        contrasenia_field.leftView = utilidades.marge_text_field(margen : 45)
        contrasenia_field.leftViewMode = UITextField.ViewMode.always
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func evento_click(_ sender: UITapGestureRecognizer) {
        correo_electronico_field.resignFirstResponder()
        contrasenia_field.resignFirstResponder()
    }
    
    @IBAction func evento_iniciar_sesion(_ sender: UIButton) {
        
        if(correo_electronico_field.text!.isEmpty){
            self.present((utilidades.alerta_personalizada(mensaje : "Por favor ingrese su correo electrónico")), animated : true, completion : nil)
        }
        else if(contrasenia_field.text!.isEmpty){
            self.present((utilidades.alerta_personalizada(mensaje : "Por favor ingrese su contraseña")), animated : true, completion : nil)
        }
        else{
            present(utilidades.indicador_carga_actividad(mensaje: "Iniciando sesión"), animated: true, completion: nil)
            
            let postString = "email=\(correo_electronico_field.text!)&password=\(contrasenia_field.text!)"
            let url = URL(string: URLs.url_validar_usuario())!
            var request = URLRequest(url: url)
            
            request.httpMethod = "POST"//
            request.httpBody = postString.data(using: .utf8)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    print("solicitud fallida \(String(describing: error))")//manejamos el error
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(Usuario.self, from: data)
                    DispatchQueue.main.sync {
                        print(response)
                        if(response.mensaje == "success"){
                            if(UsuariosEntity.shared.insert(idExpediente: response.idExpediente!, nombreCompleto: response.nombreCompleto!, idAsignacionMembresia: response.idAsignacionMembresia!, correoElectronico: response.correoElectronico!, contrasenia: self.contrasenia_field.text!)!
                                > 0){
                                self.dissmissActivityIndicator()
                                let storyboard = UIStoryboard(name: "MainMenu", bundle: nil)
                                let controlador = storyboard.instantiateViewController(withIdentifier: "MainMenuNavigation")
                                self.present(controlador, animated: true, completion: nil)
                            }
                        }else{
                            self.dissmissActivityIndicator()
                            self.present(self.utilidades.alerta_personalizada(mensaje: "Credenciales no validas."), animated: true, completion: nil)
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
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == correo_electronico_field){
            contrasenia_field.becomeFirstResponder()
        }else{
            contrasenia_field.resignFirstResponder()
        }
        return true
    }
    
    func dissmissActivityIndicator(){
        dismiss(animated: false, completion: nil)
    }
    
}

