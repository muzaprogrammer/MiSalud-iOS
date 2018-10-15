//
//  DetallesCitaController.swift
//  Mi Salud
//
//  Created by ITMED on 9/8/18.
//  Copyright © 2018 ITMED. All rights reserved.
//

import UIKit

class DetallesCitaController: UIViewController {
    
    let URLs : Uris = Uris()
    let utilidades : Utilidades = Utilidades()
    
    var idCita : Int = 0;
    
    @IBOutlet weak var paciente_field: UITextField!
    @IBOutlet weak var sucursal_field: UITextField!
    @IBOutlet weak var especialidad_field: UITextField!
    @IBOutlet weak var fecha_field: UITextField!
    @IBOutlet weak var hora_field: UITextField!
    @IBOutlet weak var observaciones_field: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.observaciones_field.layer.borderWidth = 1.0
        observaciones_field.layer.borderColor = UIColor.black.cgColor
        
        paciente_field.leftView = utilidades.marge_text_field(margen : 10)
        paciente_field.leftViewMode = UITextField.ViewMode.always
        
        sucursal_field.leftView = utilidades.marge_text_field(margen : 10)
        sucursal_field.leftViewMode = UITextField.ViewMode.always
        
        especialidad_field.leftView = utilidades.marge_text_field(margen : 10)
        especialidad_field.leftViewMode = UITextField.ViewMode.always
        
        fecha_field.leftView = utilidades.marge_text_field(margen : 10)
        fecha_field.leftViewMode = UITextField.ViewMode.always
        
        hora_field.leftView = utilidades.marge_text_field(margen : 10)
        hora_field.leftViewMode = UITextField.ViewMode.always
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        present(utilidades.indicador_carga_actividad(mensaje: "Obteniendo datos"), animated: true, completion: nil)
        self.obtener_detalles_cita()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.dissmissActivityIndicator()
        })
    }
    
    @IBAction func evento_cancelar_cita(_ sender: UIBarButtonItem) {
        let refreshAlert = UIAlertController(title: "Confirmación", message: "¿Estas seguro de cancelar la cita?", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Si", style: .default, handler: { (action: UIAlertAction!) in
            self.present(self.utilidades.indicador_carga_actividad(mensaje: "Cancelando cita"), animated: true, completion: nil)
            self.cancelar_cita()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func obtener_detalles_cita(){
        
        let postString = "idCita=\(idCita)"
        let url = URL(string: URLs.url_obtener_detalles_cita())!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"//
        request.httpBody = postString.data(using: .utf8)
        //adding the values to send with coding utf8
        
        var done = false
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("solicitud fallida \(String(describing: error))")//manejamos el error
                return
            }
            
            do {
                //creating a JSON object
                let response = try JSONDecoder().decode(Citas.self, from: data)
                DispatchQueue.main.sync {
                    self.paciente_field.text = response.nombrePaciente
                    self.sucursal_field.text = response.nombreSucursal
                    self.especialidad_field.text = response.tipoConsulta
                    self.fecha_field.text = response.fecha
                    self.hora_field.text = response.hora
                    self.observaciones_field.text = response.notas
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
    }
    
    func cancelar_cita(){
        
        let postString = "idCita=\(idCita)"
        let url = URL(string: URLs.url_cancelar_cita())!
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
                    if(response.mensaje == "success"){
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                            self.dissmissActivityIndicator()
                        })
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                            let refreshAlert = UIAlertController(title: "Exito", message: "Cita cancelada!", preferredStyle: UIAlertController.Style.alert)
                            refreshAlert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { (action: UIAlertAction!) in
                                //_ = self.navigationController?.popToRootViewController(animated: true)
                                _ = self.navigationController?.popViewController(animated: true)
                            }))
                            self.present(refreshAlert, animated: true, completion: nil)
                        })
                    }else{
                        self.present(self.utilidades.alerta_personalizada(mensaje: "La cita no pudo ser cancelada."), animated: true, completion: nil)
                    }
                }
            } catch let parseError {
                //handle error
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
    }
    
    func dissmissActivityIndicator(){
        dismiss(animated: false, completion: nil)
    }

}
