//
//  DocumentosController.swift
//  Mi Salud
//
//  Created by ITMED on 10/8/18.
//  Copyright © 2018 ITMED. All rights reserved.
//

import UIKit
import SQLite

class DocumentosController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var data = [Documentos]()
    let URLs : Uris = Uris()
    let utilidades : Utilidades = Utilidades()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        present(utilidades.indicador_carga_actividad(mensaje: "Obteniendo documentos"), animated: true, completion: nil)
        self.obtener_documentos()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.dissmissActivityIndicator()
            self.tableView.reloadData()
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.rowHeight = 70
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Atras"
        navigationItem.backBarButtonItem = backItem
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("DocumentosViewCell", owner: self, options: nil)?.first as! DocumentosViewCell
        cell.tipo_documento_label.text = data[indexPath.row].tipoDocumento
        cell.paciente_label.text = data[indexPath.row].nombrePaciente
        cell.fecha_label.text = data[indexPath.row].fecha
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let backItem = UIBarButtonItem()
        backItem.title = "Atras"
        navigationItem.backBarButtonItem = backItem
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetallesDocumentoController") as! DetallesDocumentoController
        vc.idDocumento = self.data[indexPath.row].idDocumento
        vc.idExpediente = self.data[indexPath.row].idExpediente
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func obtener_documentos(){
        self.tableView.dataSource = nil
        data.removeAll()
        var objUsuario : Usuario!
        if let usuarios : AnySequence<Row> = UsuariosEntity.shared.queryAll()
        {
            for eachuser in usuarios{
                objUsuario = UsuariosEntity.shared.getUsuario(usuario: eachuser)
            }
        }
        
        let postString = "idExpediente=0&idAsignacionMembresia=\(objUsuario.idAsignacionMembresia!)"
        let url = URL(string: URLs.url_obtener_documentos_internos())
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"//
        request.httpBody = postString.data(using: .utf8)        
        var done = false
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("solicitud fallida \(String(describing: error))")
                return
            }
            do {
                let response = try JSONDecoder().decode([Documentos].self, from: data)
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
