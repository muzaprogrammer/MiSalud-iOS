//
//  DetallesCuentaController.swift
//  Mi Salud
//
//  Created by ITMED on 11/8/18.
//  Copyright © 2018 ITMED. All rights reserved.
//

import UIKit
import SQLite

class DetallesCuentaController: UIViewController {
    
    let URLs : Uris = Uris()
    let utilidades : Utilidades = Utilidades()
    
    var idAsignacionMembresia : Int = 0
    var idCuenta : Int = 0;
    
    @IBOutlet weak var nombre_cuenta_label: UILabel!
    @IBOutlet weak var titular_cuenta_label: UILabel!
    @IBOutlet weak var fecha_activacion_label: UILabel!
    @IBOutlet weak var fecha_vencimiento_label: UILabel!
    @IBOutlet weak var consultas_gratis_label: UILabel!
    @IBOutlet weak var saldo_favor_label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nombre_cuenta_label.text = ""
        titular_cuenta_label.text = ""
        fecha_activacion_label.text = ""
        fecha_vencimiento_label.text = ""
        consultas_gratis_label.text = ""
        saldo_favor_label.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func evento_consumos(_ sender: UIBarButtonItem) {
        let backItem = UIBarButtonItem()
        backItem.title = "Atras"
        navigationItem.backBarButtonItem = backItem
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetallesCuentaConsumoController") as! DetallesCuentaConsumoController
        vc.idAsignacionMembresia = idAsignacionMembresia
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        present(utilidades.indicador_carga_actividad(mensaje: "Obteniendo datos"), animated: true, completion: nil)
        self.obtener_detalles_cuenta()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.dissmissActivityIndicator()
        })
    }
    
    func obtener_detalles_cuenta(){
        var objUsuario : Usuario!
        if let usuarios : AnySequence<Row> = UsuariosEntity.shared.queryAll()
        {
            for eachuser in usuarios{
                objUsuario = UsuariosEntity.shared.getUsuario(usuario: eachuser)
            }
        }
        let postString = "idCuenta=\(idCuenta)&idAsignacionMembresia=\(objUsuario.idAsignacionMembresia!)"
        let url = URL(string: URLs.url_obtener_detalles_cuenta())!
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
                //creating a JSON object
                let response = try JSONDecoder().decode(DetallesCuenta.self, from: data)
                DispatchQueue.main.sync {
                    self.nombre_cuenta_label.text = response.nombreCuenta
                    self.titular_cuenta_label.text = response.nombreTitular
                    self.fecha_activacion_label.text = response.fechaActivacion
                    self.fecha_vencimiento_label.text = response.fechaVencimiento
                    self.consultas_gratis_label.text = response.consultasGratis
                    self.saldo_favor_label.text = response.saldoFavor
                    self.idAsignacionMembresia = response.idAsignacionMembresia
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
