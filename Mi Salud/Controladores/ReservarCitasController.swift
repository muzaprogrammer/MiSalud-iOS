//
//  ReservarCitasController.swift
//  Mi Salud
//
//  Created by ITMED on 9/8/18.
//  Copyright © 2018 ITMED. All rights reserved.
//

import UIKit
import Foundation
import SQLite

class ReservarCitasController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let URLs : Uris                 = Uris()
    let utilidades : Utilidades     = Utilidades()
    var dataExpedientes             = [Expedientes]()
    var dataSucursales              = [Sucursales]()
    var dataEspecialidades          = [Especialidades]()
    var dataHoras                   = [Horarios]()
    
    var idExpediente : Int = 0
    var idEspecialidad : Int = 0
    var idSucursal : Int = 0
    
    @IBOutlet weak var pacientes_field: UITextField!
    @IBOutlet weak var sucursales_field: UITextField!
    @IBOutlet weak var especialidades_field: UITextField!
    @IBOutlet weak var fecha_field: UITextField!
    @IBOutlet weak var hora_field: UITextField!
    @IBOutlet weak var observaciones_field: UITextView!
    
    var pickerPacientes         = UIPickerView()
    var pickerSucursales        = UIPickerView()
    var pickerEspecialidades    = UIPickerView()
    var pickerHoras             = UIPickerView()
    
    var datePicker : UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerPacientes.delegate = self
        pickerPacientes.dataSource = self
        pickerSucursales.delegate = self
        pickerSucursales.dataSource = self
        pickerEspecialidades.delegate = self
        pickerEspecialidades.dataSource = self
        pickerHoras.delegate = self
        pickerHoras.dataSource = self
        
        pacientes_field.inputView = pickerPacientes
        sucursales_field.inputView = pickerSucursales
        especialidades_field.inputView = pickerEspecialidades
        hora_field.inputView = pickerHoras
        
        self.observaciones_field.layer.borderWidth = 1.0
        observaciones_field.layer.borderColor = UIColor.black.cgColor
        
        pacientes_field.leftView = utilidades.marge_text_field(margen : 10)
        pacientes_field.leftViewMode = UITextField.ViewMode.always
        
        sucursales_field.leftView = utilidades.marge_text_field(margen : 10)
        sucursales_field.leftViewMode = UITextField.ViewMode.always
        
        especialidades_field.leftView = utilidades.marge_text_field(margen : 10)
        especialidades_field.leftViewMode = UITextField.ViewMode.always
        
        fecha_field.leftView = utilidades.marge_text_field(margen : 10)
        fecha_field.leftViewMode = UITextField.ViewMode.always
        
        hora_field.leftView = utilidades.marge_text_field(margen : 10)
        hora_field.leftViewMode = UITextField.ViewMode.always
        
        pacientes_field.inputAccessoryView = toolbarPicker(pickerView: "Pacientes")
        sucursales_field.inputAccessoryView = toolbarPicker(pickerView: "Sucursales")
        especialidades_field.inputAccessoryView = toolbarPicker(pickerView: "Especialidades")
        hora_field.inputAccessoryView = toolbarPicker(pickerView: "Horas")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        present(utilidades.indicador_carga_actividad(mensaje: "Obteniendo datos"), animated: true, completion: nil)
        self.obtener_datos_iniciales()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.dissmissActivityIndicator()
        })
    }
    
    @IBAction func evento_click(_ sender: UITapGestureRecognizer) {
        pacientes_field.resignFirstResponder()
        sucursales_field.resignFirstResponder()
        especialidades_field.resignFirstResponder()
        fecha_field.resignFirstResponder()
        hora_field.resignFirstResponder()
        observaciones_field.resignFirstResponder()
    }
    
    func obtener_datos_iniciales(){
        
        var objUsuario : Usuario!
        if let usuarios : AnySequence<Row> = UsuariosEntity.shared.queryAll()
        {
            for eachuser in usuarios{
                objUsuario = UsuariosEntity.shared.getUsuario(usuario: eachuser)
            }
        }
        
        let horarios = Horarios(idHorario: "", horario: "No hay horarios disponibles")
        self.dataHoras = [horarios]
        
        let postString = "idAsignacionMembresia=\(objUsuario.idAsignacionMembresia!)"
        let url = URL(string: URLs.url_reservar_citas_datos_iniciales())!
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
                
                let response = try JSONDecoder().decode(ReservarCitas.self, from: data)
                DispatchQueue.main.sync {
                    self.dataSucursales = response.sucursales
                    
                    self.dataExpedientes = response.expedientes
                    
                    self.dataEspecialidades = response.especialidades
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var count : Int = 0;
        if pickerView == pickerPacientes {
            count =  dataExpedientes.count
        } else if pickerView == pickerSucursales{
            count = dataSucursales.count
        } else if pickerView == pickerEspecialidades{
            count = dataEspecialidades.count
        } else if pickerView == pickerHoras{
            count = dataHoras.count
        }
        return count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerPacientes {
            pacientes_field.text = dataExpedientes[row].nombrePaciente
        } else if pickerView == pickerSucursales{
            sucursales_field.text = dataSucursales[row].nombreSucursal
        } else if pickerView == pickerEspecialidades{
            especialidades_field.text = dataEspecialidades[row].nombreEspecialidad
        } else if pickerView == pickerHoras{
            hora_field.text = dataHoras[row].horario
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var cadena : String = ""
        if pickerView == pickerPacientes {
            cadena = dataExpedientes[row].nombrePaciente
        } else if pickerView == pickerSucursales{
            cadena = dataSucursales[row].nombreSucursal
        } else if pickerView == pickerEspecialidades{
            cadena = dataEspecialidades[row].nombreEspecialidad
        } else if pickerView == pickerHoras{
            cadena = dataHoras[row].horario
        }
        return cadena
    }
    
    func obtener_horarios_disponibles(idEspecialidad : Int, idSucursal : Int, fecha : String, diaSemana : Int){
        dataHoras.removeAll()
        hora_field.text = ""
        let postString = "idEspecialidad=\(idEspecialidad)&idSucursal=\(idSucursal)&fecha=\(fecha)&diaSemana=\(diaSemana)"
        let url = URL(string: URLs.url_obtener_horas_disponibles())!
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
                
                let response = try JSONDecoder().decode([Horarios].self, from: data)
                DispatchQueue.main.sync {
                    for eachresponse in response{
                        self.dataHoras.append(eachresponse)
                    }
                }
            } catch let parseError {
                print("error parsing: \(parseError)")
                let responseString = String(data: data, encoding: .utf8)
                print("response : \(String(describing: responseString))")
                self.present(self.utilidades.alerta_personalizada(mensaje: "Ha ocurrido un error, por favor intentelo nuevamente."), animated: true, completion: nil)
            }
            done = true
            self.dissmissActivityIndicator()
        }
        task.resume()
        repeat{
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
        }while !done
    }
    
    @IBAction func evento_guardar_cita(_ sender: UIBarButtonItem) {
        var error : Int = 0;
        var alert : UIAlertController?
        if(idExpediente == 0){
            error = error + 1
            alert = utilidades.alerta_personalizada(mensaje: "Por favor, seleccione un paciente")
        }
        else if (idSucursal == 0){
            error = error + 1
            alert = utilidades.alerta_personalizada(mensaje: "Por favor, seleccione una sucursal")
        }
        else if (idEspecialidad == 0){
            error = error + 1
            alert = utilidades.alerta_personalizada(mensaje: "Por favor, seleccione una especialidad")
        }
        else if (fecha_field.text == ""){
            error = error + 1
            alert = utilidades.alerta_personalizada(mensaje: "Por favor, seleccione la fecha para la cita")
        }
        else if (hora_field.text == "" || hora_field.text == "No hay horario disponible"){
            error = error + 1
            alert = utilidades.alerta_personalizada(mensaje: "Por favor, seleccione la hora para la cita")
        }
        if(error == 0){
            let refreshAlert = UIAlertController(title: "Confirmación", message: "¿Todos los datos son correctos?", preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Si", style: .default, handler: { (action: UIAlertAction!) in
                self.present(self.utilidades.indicador_carga_actividad(mensaje: "Guardando cita"), animated: true, completion: nil)
                self.guardar_cita(idExpediente: self.idExpediente, fechaReservacion: self.fecha_field.text!, horario: self.hora_field.text!, idEspecialidad: self.idEspecialidad, observaciones: self.observaciones_field.text, idSucursal: self.idSucursal)
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            present(refreshAlert, animated: true, completion: nil)
        }else{
            self.present(alert!, animated: true, completion: nil)
        }
    }
    
    @IBAction func evento_datepicker(_ sender: UITextField) {
        self.pickUpDate(self.fecha_field)
    }
    
    func dissmissActivityIndicator(){
        dismiss(animated: false, completion: nil)
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        fecha_field.text = dateFormatter.string(from: sender.date)
    }
    
    func pickUpDate(_ textField : UITextField){
        
        // DatePicker
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.datePickerMode = UIDatePicker.Mode.date
        textField.inputView = self.datePicker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Listo", style: UIBarButtonItem.Style.plain, target: self, action: #selector(aceptarClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancelar", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelarClick))
        cancelButton.tintColor = UIColor.black
        doneButton.tintColor = UIColor.black
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    
    @objc func aceptarClick() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        fecha_field.text = dateFormatter.string(from: datePicker.date)
        fecha_field.resignFirstResponder()
        present(utilidades.indicador_carga_actividad(mensaje: "Consultando horarios"), animated: true, completion: nil)
        obtener_horarios_disponibles(idEspecialidad: idEspecialidad, idSucursal: idSucursal, fecha: utilidades.formato_fecha(fecha: datePicker.date), diaSemana: utilidades.obtener_dia_semana(fecha: datePicker.date))
        
    }
    
    @objc func cancelarClick() {
        fecha_field.resignFirstResponder()
    }
    
    @objc func aceptarClickPacientes(){
        let indexPath = pickerPacientes.selectedRow(inComponent: 0)
        pacientes_field.text = dataExpedientes[indexPath].nombrePaciente
        idExpediente = dataExpedientes[indexPath].idExpediente
        pacientes_field.resignFirstResponder()
    }
    
    @objc func cancelarClickPacientes() {
        pacientes_field.resignFirstResponder()
    }
    
    @objc func aceptarClickSucursales(){
        let indexPath = pickerSucursales.selectedRow(inComponent: 0)
        sucursales_field.text = dataSucursales[indexPath].nombreSucursal
        idSucursal = dataSucursales[indexPath].idSucursal
        sucursales_field.resignFirstResponder()
    }
    
    @objc func cancelarClickSucursales() {
        sucursales_field.resignFirstResponder()
    }
    
    @objc func aceptarClickEspecialidades(){
        let indexPath = pickerEspecialidades.selectedRow(inComponent: 0)
        especialidades_field.text = dataEspecialidades[indexPath].nombreEspecialidad
        idEspecialidad = dataEspecialidades[indexPath].idEspecialidad
        especialidades_field.resignFirstResponder()
    }
    
    @objc func cancelarClickEspecialidades() {
        especialidades_field.resignFirstResponder()
    }
    
    @objc func aceptarClickHoras(){
        let indexPath = pickerHoras.selectedRow(inComponent: 0)
        if(dataHoras.count > 0)
        {
            hora_field.text = dataHoras[indexPath].horario
        }
        hora_field.resignFirstResponder()
    }
    
    @objc func cancelarClickHoras() {
        hora_field.resignFirstResponder()
    }
    
    func guardar_cita(idExpediente : Int, fechaReservacion : String, horario : String, idEspecialidad : Int, observaciones : String, idSucursal : Int){
        
        let postString = "idExpediente=\(idExpediente)&fechaReservacion=\(fechaReservacion)&horario=\(horario)&idEspecialidad=\(idEspecialidad)&observaciones=\(observaciones)&idSucursal=\(idSucursal)"
        let url = URL(string: URLs.url_guardar_cita())!
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
                            let refreshAlert = UIAlertController(title: "Exito", message: "Cita reservada!", preferredStyle: UIAlertController.Style.alert)
                            refreshAlert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { (action: UIAlertAction!) in
                                //_ = self.navigationController?.popToRootViewController(animated: true)
                                _ = self.navigationController?.popViewController(animated: true)
                            }))
                            self.present(refreshAlert, animated: true, completion: nil)
                        })
                    }else{
                        self.present(self.utilidades.alerta_personalizada(mensaje: "La cita no pudo ser reservada."), animated: true, completion: nil)
                    }
                }
            } catch let parseError {
                //handle error
                print("error parsing: \(parseError)")
                let responseString = String(data: data, encoding: .utf8)
                print("response : \(String(describing: responseString))")
                self.present(self.utilidades.alerta_personalizada(mensaje: "Ha ocurrido un error, por favor intentelo nuevamente."), animated: true, completion: nil)
            }
        }
        task.resume()
    }
    
    func toolbarPicker(pickerView : String) -> UIToolbar{
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        var doneButton : UIBarButtonItem?
        var spaceButton : UIBarButtonItem?
        var cancelButton : UIBarButtonItem?
        
        switch pickerView {
        case "Pacientes":
            doneButton = UIBarButtonItem(title: "Aceptar", style: UIBarButtonItem.Style.plain, target: self, action: #selector(aceptarClickPacientes))
            spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            cancelButton = UIBarButtonItem(title: "Cancelar", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelarClickPacientes))
            break;
        case "Sucursales":
            doneButton = UIBarButtonItem(title: "Aceptar", style: UIBarButtonItem.Style.plain, target: self, action: #selector(aceptarClickSucursales))
            spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            cancelButton = UIBarButtonItem(title: "Cancelar", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelarClickSucursales))
            break;
        case "Especialidades":
            doneButton = UIBarButtonItem(title: "Aceptar", style: UIBarButtonItem.Style.plain, target: self, action: #selector(aceptarClickEspecialidades))
            spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            cancelButton = UIBarButtonItem(title: "Cancelar", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelarClickEspecialidades))
            break;
        case "Horas":
            doneButton = UIBarButtonItem(title: "Aceptar", style: UIBarButtonItem.Style.plain, target: self, action: #selector(aceptarClickHoras))
            spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            cancelButton = UIBarButtonItem(title: "Cancelar", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelarClickHoras))
            break;
        default: break
            
        }
        
        toolBar.setItems([cancelButton!, spaceButton!, doneButton!], animated: false)
        
        cancelButton?.tintColor = UIColor.black
        doneButton?.tintColor = UIColor.black
        toolBar.isUserInteractionEnabled = true
        
        
        return toolBar
    }
    
}
