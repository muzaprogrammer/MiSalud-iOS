//
//  DatosGeneralesController.swift
//  Mi Salud
//
//  Created by ITMED on 9/8/18.
//  Copyright © 2018 ITMED. All rights reserved.
//

import UIKit
import SQLite

class DatosGeneralesController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var titular_field: UITextField!
    @IBOutlet weak var fecha_nacimiento_field: UITextField!
    @IBOutlet weak var correo_electronico_field: UITextField!
    @IBOutlet weak var telefono_celular_field: UITextField!
    @IBOutlet weak var telefono_casa_field: UITextField!
    
    let URLs : Uris = Uris()
    let utilidades : Utilidades = Utilidades()
    
    var idExpediente : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titular_field.leftView = utilidades.marge_text_field(margen : 10)
        titular_field.leftViewMode = UITextField.ViewMode.always
        
        fecha_nacimiento_field.leftView = utilidades.marge_text_field(margen : 10)
        fecha_nacimiento_field.leftViewMode = UITextField.ViewMode.always
        
        correo_electronico_field.leftView = utilidades.marge_text_field(margen : 10)
        correo_electronico_field.leftViewMode = UITextField.ViewMode.always
        
        telefono_celular_field.leftView = utilidades.marge_text_field(margen : 10)
        telefono_celular_field.leftViewMode = UITextField.ViewMode.always
        
        telefono_casa_field.leftView = utilidades.marge_text_field(margen : 10)
        telefono_casa_field.leftViewMode = UITextField.ViewMode.always
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        var objUsuario : Usuario!
        if let usuarios : AnySequence<Row> = UsuariosEntity.shared.queryAll()
        {
            for eachuser in usuarios{
                objUsuario = UsuariosEntity.shared.getUsuario(usuario: eachuser)
            }
        }
        titular_field.text = objUsuario.nombreCompleto
        idExpediente = objUsuario.idExpediente!
        present(utilidades.indicador_carga_actividad(mensaje: "Obteniendo datos"), animated: true, completion: nil)
        self.obtener_datos_generales()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Atras"
        navigationItem.backBarButtonItem = backItem
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == correo_electronico_field){
            telefono_celular_field.becomeFirstResponder()
        }else if(textField == telefono_casa_field){
            telefono_casa_field.becomeFirstResponder()
        }else{
            telefono_casa_field.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func evento_editar_datos_generales(_ sender: UIBarButtonItem) {
        let refreshAlert = UIAlertController(title: "Confirmación", message: "¿Estas seguro de actualizar tus datos?", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Si", style: .default, handler: { (action: UIAlertAction!) in
            self.present(self.utilidades.indicador_carga_actividad(mensaje: "Guardando cambios"), animated: true, completion: nil)
            self.actualizar_datos_generales()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    @IBAction func evento_click(_ sender: UITapGestureRecognizer) {
        correo_electronico_field.resignFirstResponder()
        telefono_casa_field.resignFirstResponder()
        telefono_celular_field.resignFirstResponder()
    }
    
    func obtener_datos_generales(){
        
        let postString = "idExpediente=\(idExpediente)"
        let url = URL(string: URLs.url_obtener_datos_generales())!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"//
        request.httpBody = postString.data(using: .utf8)
        
        var done = false
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("solicitud fallida \(String(describing: error))")//manejamos el error
                return
            }
            do {
                let response = try JSONDecoder().decode(DatosGenerales.self, from: data)
                DispatchQueue.main.sync {
                    self.fecha_nacimiento_field.text = response.fechaNacimiento
                    self.correo_electronico_field.text = response.correoElectronico
                    self.telefono_celular_field.text = response.telefonoCelular
                    self.telefono_casa_field.text = response.telefonoCasa
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    self.dissmissActivityIndicator()
                })
            } catch let parseError {
                print("error parsing: \(parseError)")
                let responseString = String(data: data, encoding: .utf8)
                print("response : \(String(describing: responseString))")
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    self.dissmissActivityIndicator()
                })
                self.present(self.utilidades.alerta_personalizada(mensaje: "Ha ocurrido un error, por favor intentelo nuevamente."), animated: true, completion: nil)
            }
            done = true
        }
        task.resume()
        repeat{
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
        }while !done
    }
    
    func actualizar_datos_generales(){
        if(correo_electronico_field.text != "" && utilidades.es_correo_valido(correo_electronico: correo_electronico_field.text!.trimmingCharacters(in: .whitespacesAndNewlines))){
            let postString = "idExpediente=\(idExpediente)&correoElectronico=\(correo_electronico_field.text ?? "")&telefonoCasa=\(telefono_casa_field.text ?? ""))&telefonoCel=\(telefono_celular_field.text ?? ""))"
            let url = URL(string: URLs.url_actualizar_datos_generales())!
            var request = URLRequest(url: url)
            
            request.httpMethod = "POST"//
            request.httpBody = postString.data(using: .utf8)
            var done = false
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    print("solicitud fallida \(String(describing: error))")//manejamos el error
                    return
                }
                do {
                    let response = try JSONDecoder().decode(Respuesta.self, from: data)
                    DispatchQueue.main.sync {
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                            self.dissmissActivityIndicator()
                        })
                        if(response.mensaje == "success"){
                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                                let refreshAlert = UIAlertController(title: "Exito", message: "Datos actualizados!", preferredStyle: UIAlertController.Style.alert)
                                refreshAlert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { (action: UIAlertAction!) in
                                    UsuariosEntity.shared.updateCorreoElectronicoUsuario(id: self.idExpediente, correo: self.correo_electronico_field.text!)
                                    
                                }))
                                self.present(refreshAlert, animated: true, completion: nil)
                            })
                        }else{
                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                                self.present(self.utilidades.alerta_personalizada(mensaje: "Los datos no pudieron ser actualizados."), animated: true, completion: nil)
                            })
                        }
                    }
                } catch let parseError {
                    print("error parsing: \(parseError)")
                    let responseString = String(data: data, encoding: .utf8)
                    print("response : \(String(describing: responseString))")
                    self.present(self.utilidades.alerta_personalizada(mensaje: "Ha ocurrido un error, por favor intentelo nuevamente."), animated: true, completion: nil)
                }
                done = true
            }
            task.resume()
            repeat{
                RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
            }while !done
        }else{
            self.present(self.utilidades.alerta_personalizada(mensaje: "Por favor, ingrese una dirección de correo electrónico valida"), animated: true, completion: nil)
        }
    }

    func dissmissActivityIndicator(){
        dismiss(animated: false, completion: nil)
    }
}
