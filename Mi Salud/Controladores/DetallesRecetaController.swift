//
//  DetallesRecetaController.swift
//  Mi Salud
//
//  Created by ITMED on 11/8/18.
//  Copyright © 2018 ITMED. All rights reserved.
//

import UIKit
import SQLite

class DetallesRecetaController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var data = [DetallesReceta]()
    let URLs : Uris = Uris()
    let utilidades : Utilidades = Utilidades()
    
    var idReceta : Int = 0;
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("DetallesRecetaViewCell", owner: self, options: nil)?.first as! DetallesRecetaViewCell
        cell.medicamento_label.text = data[indexPath.row].nombreMedicamento
        cell.cantidad_label.text = data[indexPath.row].cantidad
        cell.tiempo_label.text = data[indexPath.row].periodo
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        present(utilidades.indicador_carga_actividad(mensaje: "Obteniendo detalles"), animated: true, completion: nil)
        self.obtener_detalles_recetas()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.dissmissActivityIndicator()
            self.tableView.reloadData()
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.rowHeight = 50
        })
    }
    
    func obtener_detalles_recetas(){
        self.tableView.dataSource = nil
        data.removeAll()
        
        let postString = "idReceta=\(idReceta)"
        let url = URL(string: URLs.url_obtener_detalles_recetas())
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"//
        request.httpBody = postString.data(using: .utf8)
        var done = false
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("solicitud fallida \(String(describing: error))")//manejamos el error
                return
            }
            do {
                let response = try JSONDecoder().decode([DetallesReceta].self, from: data)
                DispatchQueue.main.sync {
                    for eachresponse in response{
                        self.data.append(eachresponse)
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
    }
    
    func dissmissActivityIndicator(){
        dismiss(animated: false, completion: nil)
    }

}
