//
//  ContactanosController.swift
//  Mi Salud
//
//  Created by ITMED on 9/8/18.
//  Copyright © 2018 ITMED. All rights reserved.
//

import UIKit
import SQLite

class ContactanosController: UIViewController {

    @IBOutlet weak var usuario_field: UITextField!
    @IBOutlet weak var mensaje_field: UITextView!
    
    let utilidades : Utilidades = Utilidades()
    let URLs : Uris = Uris()
    var objUsuario : Usuario!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mensaje_field.layer.borderWidth = 1.0
        mensaje_field.layer.borderColor = UIColor.black.cgColor
        if let usuarios : AnySequence<Row> = UsuariosEntity.shared.queryAll()
        {
            for eachuser in usuarios{
                objUsuario = UsuariosEntity.shared.getUsuario(usuario: eachuser)
            }
        }
        usuario_field.text = objUsuario.nombreCompleto
        
        usuario_field.leftView = utilidades.marge_text_field(margen : 10)
        usuario_field.leftViewMode = UITextField.ViewMode.always
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func evento_click(_ sender: UITapGestureRecognizer) {
        mensaje_field.resignFirstResponder()
    }
    
    @IBAction func evento_enviar_mensaje(_ sender: UIBarButtonItem) {
        if(mensaje_field.text == ""){
            self.present(self.utilidades.alerta_personalizada(mensaje: "Por favor, escriba un mensaje"), animated: true, completion: nil)
        }else{
            let refreshAlert = UIAlertController(title: "Confirmación", message: "¿Deseas enviar el mensaje?", preferredStyle: UIAlertController.Style.alert)
            refreshAlert.addAction(UIAlertAction(title: "Si", style: .default, handler: { (action: UIAlertAction!) in
                self.present(self.utilidades.indicador_carga_actividad(mensaje: "Enviando mensaje"), animated: true, completion: nil)
                self.enviar_mensaje()
            }))
            refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
            }))
            present(refreshAlert, animated: true, completion: nil)
        }
    }
    
    func enviar_mensaje(){
        
        let postString = "idExpediente=\(objUsuario.idExpediente!)&mensaje=\(mensaje_field.text!)"
        let url = URL(string: URLs.url_contactanos())!
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
                            let refreshAlert = UIAlertController(title: "Exito", message: "Mensaje enviado!", preferredStyle: UIAlertController.Style.alert)
                            refreshAlert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { (action: UIAlertAction!) in
                                _ = self.navigationController?.popViewController(animated: true)
                            }))
                            self.present(refreshAlert, animated: true, completion: nil)
                        })
                    }else{
                        self.present(self.utilidades.alerta_personalizada(mensaje: "Error al enviar el mensaje."), animated: true, completion: nil)
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
    
    func dissmissActivityIndicator(){
        dismiss(animated: false, completion: nil)
    }
    
}
