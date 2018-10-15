//
//  RecuperarContraseniaController.swift
//  Mi Salud
//
//  Created by ITMED on 6/8/18.
//  Copyright © 2018 ITMED. All rights reserved.
//

import UIKit

class RecuperarContraseniaController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var correo_electronico_field: UITextField!
    let utilidades : Utilidades = Utilidades()
    let URLs : Uris = Uris()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        correo_electronico_field.delegate = self
        correo_electronico_field.leftView = utilidades.marge_text_field(margen : 45)
        correo_electronico_field.leftViewMode = UITextField.ViewMode.always

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func evento_click(_ sender: UITapGestureRecognizer) {
        correo_electronico_field.resignFirstResponder()
    }
    
    @IBAction func evento_enviar_correo_electronico(_ sender: UIButton) {
        if(utilidades.es_correo_valido(correo_electronico: correo_electronico_field.text!.trimmingCharacters(in: .whitespacesAndNewlines))){
            present(self.utilidades.indicador_carga_actividad(mensaje: "Procesando la petición"), animated: true, completion: nil)
            let postString = "email=\(correo_electronico_field.text!)"
            let url = URL(string: URLs.url_restaurar_contrasenia())!
            var request = URLRequest(url: url)
            
            request.httpMethod = "POST"//
            request.httpBody = postString.data(using: .utf8)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    //if exists an error, finish the proces
                    print("solicitud fallida \(String(describing: error))")//manejamos el error
                    return
                    //finish proces
                }
                
                do {
                    //creating a JSON object
                    let response = try JSONDecoder().decode(CodigoRespuesta.self, from: data)
                    DispatchQueue.main.sync {
                        //main proces
                        //save the user into tblusuarios
                        print(response)
                        if(response.respuesta == 0){
                            self.dissmissActivityIndicator()
                            self.present(self.utilidades.alerta_personalizada(mensaje: "Por favor, verifica tu buzón de correo electrónico para completar el proceso de ingreso a tu cuenta"), animated: true, completion: nil)
                        }else if (response.respuesta == 1){
                            self.dissmissActivityIndicator()
                            self.present(self.utilidades.alerta_personalizada(mensaje: "Ha ocurrido un error, por favor intentelo nuevamente"), animated: true, completion: nil)
                        }else{
                            self.dissmissActivityIndicator()
                            self.present(self.utilidades.alerta_personalizada(mensaje: "El correo electrónico ingresado, no se encuentra registrado en nuestra base de datos"), animated: true, completion: nil)
                        }
                    }
                } catch let parseError {
                    //handle error
                    print("error parsing: \(parseError)")
                    let responseString = String(data: data, encoding: .utf8)
                    print("response : \(String(describing: responseString))")
                    self.present(self.utilidades.alerta_personalizada(mensaje: "Ha ocurrido un error, por favor intentelo nuevamente"), animated: true, completion: nil)
                }
            }
            task.resume()
            
        }else{
            self.present(self.utilidades.alerta_personalizada(mensaje: "Por favor, ingrese una dirección de correo electrónico valida"), animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        correo_electronico_field.resignFirstResponder()
        return true
    }
    
    func dissmissActivityIndicator(){
        dismiss(animated: false, completion: nil)
    }
    
}
