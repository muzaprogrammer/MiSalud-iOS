//
//  DetallesConsultasMedicasController.swift
//  Mi Salud
//
//  Created by ITMED on 10/8/18.
//  Copyright © 2018 ITMED. All rights reserved.
//

import UIKit

class DetallesConsultasMedicasController: UIViewController {
    
    let URLs : Uris = Uris()
    let utilidades : Utilidades = Utilidades()
    
    var idConsulta : Int = 0;
    
    @IBOutlet weak var fecha_field: UITextField!
    @IBOutlet weak var hora_field: UITextField!
    @IBOutlet weak var paciente_field: UITextField!
    @IBOutlet weak var diagnostico_field: UITextField!
    @IBOutlet weak var motivo_consulta_field: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.motivo_consulta_field.layer.borderWidth = 1.0
        motivo_consulta_field.layer.borderColor = UIColor.black.cgColor
        
        fecha_field.leftView = utilidades.marge_text_field(margen : 10)
        fecha_field.leftViewMode = UITextField.ViewMode.always
        
        hora_field.leftView = utilidades.marge_text_field(margen : 10)
        hora_field.leftViewMode = UITextField.ViewMode.always
        
        paciente_field.leftView = utilidades.marge_text_field(margen : 10)
        paciente_field.leftViewMode = UITextField.ViewMode.always
        
        diagnostico_field.leftView = utilidades.marge_text_field(margen : 10)
        diagnostico_field.leftViewMode = UITextField.ViewMode.always
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        present(utilidades.indicador_carga_actividad(mensaje: "Obteniendo detalles"), animated: true, completion: nil)
        self.obtener_detalles_consulta()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.dissmissActivityIndicator()
        })
    }
    
    func obtener_detalles_consulta(){
        
        let postString = "idConsulta=\(idConsulta)"
        let url = URL(string: URLs.url_obtener_detalles_consulta())!
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
                let response = try JSONDecoder().decode(DetallesConsultas.self, from: data)
                DispatchQueue.main.sync {
                    self.fecha_field.text = response.fecha
                    self.hora_field.text = response.hora
                    self.paciente_field.text = response.nombrePaciente
                    self.diagnostico_field.text = response.diagnostico
                    self.motivo_consulta_field.text = response.motivoConsulta
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
    
    func dissmissActivityIndicator(){
        dismiss(animated: false, completion: nil)
    }
    
}
